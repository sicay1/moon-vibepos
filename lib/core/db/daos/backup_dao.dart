import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/customers_table.dart';
import '../tables/ice_levels_table.dart';
import '../tables/order_item_toppings_table.dart';
import '../tables/order_items_table.dart';
import '../tables/orders_table.dart';
import '../tables/product_ice_levels_table.dart';
import '../tables/product_sizes_table.dart';
import '../tables/product_sweet_levels_table.dart';
import '../tables/products_table.dart';
import '../tables/sizes_table.dart';
import '../tables/sub_products_table.dart';
import '../tables/suppliers_table.dart';
import '../tables/sweet_levels_table.dart';

part 'backup_dao.g.dart';

@DriftAccessor(tables: [
  Categories,
  Products,
  SubProducts,
  Customers,
  Suppliers,
  Orders,
  OrderItems,
  OrderItemToppings,
  Sizes,
  IceLevels,
  SweetLevels,
  ProductSizes,
  ProductIceLevels,
  ProductSweetLevels,
])
class BackupDao extends DatabaseAccessor<AppDatabase> with _$BackupDaoMixin {
  BackupDao(super.db);

  /// Export every table as a plain-Dart map. Image paths are left as-is;
  /// the provider layer is responsible for copying files into the archive.
  Future<Map<String, dynamic>> exportAll() async {
    return {
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories':
          (await select(categories).get()).map((r) => r.toJson()).toList(),
      'products':
          (await select(products).get()).map((r) => r.toJson()).toList(),
      'subProducts':
          (await select(subProducts).get()).map((r) => r.toJson()).toList(),
      'customers':
          (await select(customers).get()).map((r) => r.toJson()).toList(),
      'suppliers':
          (await select(suppliers).get()).map((r) => r.toJson()).toList(),
      'sizes': (await select(sizes).get()).map((r) => r.toJson()).toList(),
      'iceLevels':
          (await select(iceLevels).get()).map((r) => r.toJson()).toList(),
      'sweetLevels':
          (await select(sweetLevels).get()).map((r) => r.toJson()).toList(),
      'productSizes':
          (await select(productSizes).get()).map((r) => r.toJson()).toList(),
      'productIceLevels':
          (await select(productIceLevels).get()).map((r) => r.toJson()).toList(),
      'productSweetLevels': (await select(productSweetLevels).get())
          .map((r) => r.toJson())
          .toList(),
      'orders': (await select(orders).get()).map((r) => r.toJson()).toList(),
      'orderItems':
          (await select(orderItems).get()).map((r) => r.toJson()).toList(),
      'orderItemToppings': (await select(orderItemToppings).get())
          .map((r) => r.toJson())
          .toList(),
    };
  }

  /// Insert all rows from an exported data map, in FK-dependency order.
  /// Call [CleanupDao.factoryReset] before calling this to start clean.
  Future<void> importAll(Map<String, dynamic> data) =>
      transaction(() async {
        // ── Schema migration: v1 old → v1 new ─────────────────────────────
        // Old format stored price on the sizes table (global per-size price).
        // New format stores price on productSizes (per-product-per-size price).
        // If productSizes entries are missing the 'price' field, migrate by
        // copying the global size price into each productSizes entry.
        final rawProductSizes = _list(data, 'productSizes');
        if (rawProductSizes.isNotEmpty &&
            !rawProductSizes.first.containsKey('price')) {
          final sizeIdToPrice = {
            for (final s in _list(data, 'sizes'))
              s['id'] as int: (s['price'] as num?)?.toDouble() ?? 0.0,
          };
          data = Map<String, dynamic>.from(data);
          data['productSizes'] = rawProductSizes
              .map((ps) => {
                    ...ps,
                    'price': sizeIdToPrice[ps['sizeId'] as int] ?? 0.0,
                  })
              .toList();
        }
        // ──────────────────────────────────────────────────────────────────
        for (final m in _list(data, 'categories')) {
          await into(categories)
              .insertOnConflictUpdate(Category.fromJson(m));
        }
        for (final m in _list(data, 'products')) {
          await into(products).insertOnConflictUpdate(Product.fromJson(m));
        }
        for (final m in _list(data, 'subProducts')) {
          await into(subProducts)
              .insertOnConflictUpdate(SubProduct.fromJson(m));
        }
        for (final m in _list(data, 'customers')) {
          await into(customers).insertOnConflictUpdate(Customer.fromJson(m));
        }
        for (final m in _list(data, 'suppliers')) {
          await into(suppliers).insertOnConflictUpdate(Supplier.fromJson(m));
        }
        for (final m in _list(data, 'sizes')) {
          await into(sizes).insertOnConflictUpdate(Size.fromJson(m));
        }
        for (final m in _list(data, 'iceLevels')) {
          await into(iceLevels).insertOnConflictUpdate(IceLevel.fromJson(m));
        }
        for (final m in _list(data, 'sweetLevels')) {
          await into(sweetLevels)
              .insertOnConflictUpdate(SweetLevel.fromJson(m));
        }
        for (final m in _list(data, 'productSizes')) {
          await into(productSizes)
              .insertOnConflictUpdate(ProductSize.fromJson(m));
        }
        for (final m in _list(data, 'productIceLevels')) {
          await into(productIceLevels)
              .insertOnConflictUpdate(ProductIceLevel.fromJson(m));
        }
        for (final m in _list(data, 'productSweetLevels')) {
          await into(productSweetLevels)
              .insertOnConflictUpdate(ProductSweetLevel.fromJson(m));
        }
        for (final m in _list(data, 'orders')) {
          await into(orders).insertOnConflictUpdate(Order.fromJson(m));
        }
        for (final m in _list(data, 'orderItems')) {
          await into(orderItems)
              .insertOnConflictUpdate(OrderItem.fromJson(m));
        }
        for (final m in _list(data, 'orderItemToppings')) {
          await into(orderItemToppings)
              .insertOnConflictUpdate(OrderItemTopping.fromJson(m));
        }
      });

  List<Map<String, dynamic>> _list(Map<String, dynamic> data, String key) =>
      ((data[key] as List? ?? []).cast<Map<String, dynamic>>());
}
