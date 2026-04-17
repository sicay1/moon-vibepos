import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sizes_table.dart';
import '../tables/ice_levels_table.dart';
import '../tables/sweet_levels_table.dart';
import '../tables/product_sizes_table.dart';
import '../tables/product_ice_levels_table.dart';
import '../tables/product_sweet_levels_table.dart';

part 'options_dao.g.dart';

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

  Stream<List<Size>> watchSizesForProduct(int productId) {
    final query = select(sizes).join([
      innerJoin(
        productSizes,
        productSizes.sizeId.equalsExp(sizes.id) &
            productSizes.productId.equals(productId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(sizes.sortOrder)]);
    return query.map((row) => row.readTable(sizes)).watch();
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

  // ── Create global options ─────────────────────────────────────────────────

  Future<int> insertSize(SizesCompanion entry) =>
      into(sizes).insert(entry);

  Future<int> insertIceLevel(IceLevelsCompanion entry) =>
      into(iceLevels).insert(entry);

  Future<int> insertSweetLevel(SweetLevelsCompanion entry) =>
      into(sweetLevels).insert(entry);

  Future<int> deleteSize(int id) =>
      (delete(sizes)..where((t) => t.id.equals(id))).go();

  Future<int> deleteIceLevel(int id) =>
      (delete(iceLevels)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSweetLevel(int id) =>
      (delete(sweetLevels)..where((t) => t.id.equals(id))).go();

  // ── Toggle product options ────────────────────────────────────────────────

  Future<void> setProductSize(
      int productId, int sizeId, bool enabled) async {
    if (enabled) {
      await into(productSizes).insertOnConflictUpdate(
        ProductSizesCompanion.insert(productId: productId, sizeId: sizeId),
      );
    } else {
      await (delete(productSizes)
            ..where(
                (t) => t.productId.equals(productId) & t.sizeId.equals(sizeId)))
          .go();
    }
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

  Future<void> updateSizePrice(int id, double price) {
    return (update(sizes)..where((t) => t.id.equals(id)))
        .write(SizesCompanion(price: Value(price)));
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
