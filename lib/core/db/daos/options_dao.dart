import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sizes_table.dart';
import '../tables/ice_levels_table.dart';
import '../tables/sweet_levels_table.dart';
import '../tables/product_sizes_table.dart';
import '../tables/product_ice_levels_table.dart';
import '../tables/product_sweet_levels_table.dart';

part 'options_dao.g.dart';

/// Per-product size option: carries the size label/sortOrder from [Sizes] but
/// the price from [ProductSizes] so each product owns its own pricing.
class ProductSizeOption {
  final int sizeId;
  final String label;
  final double price;
  final int sortOrder;

  const ProductSizeOption({
    required this.sizeId,
    required this.label,
    required this.price,
    required this.sortOrder,
  });
}

@DriftAccessor(tables: [
  Sizes,
  IceLevels,
  SweetLevels,
  ProductSizes,
  ProductIceLevels,
  ProductSweetLevels,
])
class OptionsDao extends DatabaseAccessor<AppDatabase> with _$OptionsDaoMixin {
  OptionsDao(super.db);

  // ── Global watch ──────────────────────────────────────────────────────────

  Stream<List<Size>> watchAllSizes() =>
      (select(sizes)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).watch();

  Stream<List<IceLevel>> watchAllIceLevels() =>
      (select(iceLevels)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Stream<List<SweetLevel>> watchAllSweetLevels() =>
      (select(sweetLevels)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  // ── Per-product watch ─────────────────────────────────────────────────────

  /// Returns sizes assigned to [productId] with their **per-product** price.
  Stream<List<ProductSizeOption>> watchProductSizeOptions(int productId) {
    final query = select(sizes).join([
      innerJoin(
        productSizes,
        productSizes.sizeId.equalsExp(sizes.id) &
            productSizes.productId.equals(productId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(sizes.sortOrder)]);
    return query.map((row) {
      final s = row.readTable(sizes);
      final ps = row.readTable(productSizes);
      return ProductSizeOption(
        sizeId: s.id,
        label: s.label,
        price: ps.price,
        sortOrder: s.sortOrder,
      );
    }).watch();
  }

  Stream<List<IceLevel>> watchIceLevelsForProduct(int productId) {
    final query = select(iceLevels).join([
      innerJoin(
        productIceLevels,
        productIceLevels.iceLevelId.equalsExp(iceLevels.id) &
            productIceLevels.productId.equals(productId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(iceLevels.sortOrder)]);
    return query.map((row) => row.readTable(iceLevels)).watch();
  }

  Stream<List<SweetLevel>> watchSweetLevelsForProduct(int productId) {
    final query = select(sweetLevels).join([
      innerJoin(
        productSweetLevels,
        productSweetLevels.sweetLevelId.equalsExp(sweetLevels.id) &
            productSweetLevels.productId.equals(productId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(sweetLevels.sortOrder)]);
    return query.map((row) => row.readTable(sweetLevels)).watch();
  }

  // ── Create / update / delete global options ───────────────────────────────

  Future<int> insertSize(SizesCompanion entry) =>
      into(sizes).insert(entry);

  Future<int> insertIceLevel(IceLevelsCompanion entry) =>
      into(iceLevels).insert(entry);

  Future<int> insertSweetLevel(SweetLevelsCompanion entry) =>
      into(sweetLevels).insert(entry);

  Future<void> updateSize(int id, String label, double price, int sortOrder) =>
      (update(sizes)..where((t) => t.id.equals(id))).write(
        SizesCompanion(
          label: Value(label),
          price: Value(price),
          sortOrder: Value(sortOrder),
        ),
      );

  Future<void> updateIceLevel(int id, String label, int sortOrder) =>
      (update(iceLevels)..where((t) => t.id.equals(id))).write(
        IceLevelsCompanion(label: Value(label), sortOrder: Value(sortOrder)),
      );

  Future<void> updateSweetLevel(int id, String label, int sortOrder) =>
      (update(sweetLevels)..where((t) => t.id.equals(id))).write(
        SweetLevelsCompanion(label: Value(label), sortOrder: Value(sortOrder)),
      );

  Future<int> deleteSize(int id) =>
      (delete(sizes)..where((t) => t.id.equals(id))).go();

  Future<int> deleteIceLevel(int id) =>
      (delete(iceLevels)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSweetLevel(int id) =>
      (delete(sweetLevels)..where((t) => t.id.equals(id))).go();

  // ── Toggle / update product options ──────────────────────────────────────

  /// Enable or disable a size for a product. When enabling, [price] is stored
  /// in [ProductSizes] as the per-product price for that size.
  Future<void> setProductSize(
      int productId, int sizeId, bool enabled, {double price = 0}) async {
    if (enabled) {
      await into(productSizes).insertOnConflictUpdate(
        ProductSizesCompanion.insert(
          productId: productId,
          sizeId: sizeId,
          price: Value(price),
        ),
      );
    } else {
      await (delete(productSizes)
            ..where(
                (t) => t.productId.equals(productId) & t.sizeId.equals(sizeId)))
          .go();
    }
  }

  /// Update only the price of an already-assigned size for a specific product.
  Future<void> updateProductSizePrice(
      int productId, int sizeId, double price) {
    return (update(productSizes)
          ..where(
              (t) => t.productId.equals(productId) & t.sizeId.equals(sizeId)))
        .write(ProductSizesCompanion(price: Value(price)));
  }

  Future<void> setProductIceLevel(
      int productId, int iceLevelId, bool enabled) async {
    if (enabled) {
      await into(productIceLevels).insertOnConflictUpdate(
        ProductIceLevelsCompanion.insert(
            productId: productId, iceLevelId: iceLevelId),
      );
    } else {
      await (delete(productIceLevels)
            ..where((t) =>
                t.productId.equals(productId) &
                t.iceLevelId.equals(iceLevelId)))
          .go();
    }
  }

  Future<void> setProductSweetLevel(
      int productId, int sweetLevelId, bool enabled) async {
    if (enabled) {
      await into(productSweetLevels).insertOnConflictUpdate(
        ProductSweetLevelsCompanion.insert(
            productId: productId, sweetLevelId: sweetLevelId),
      );
    } else {
      await (delete(productSweetLevels)
            ..where((t) =>
                t.productId.equals(productId) &
                t.sweetLevelId.equals(sweetLevelId)))
          .go();
    }
  }
}
