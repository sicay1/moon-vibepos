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

part 'cleanup_dao.g.dart';

@DriftAccessor(tables: [
  Orders,
  OrderItems,
  OrderItemToppings,
  Customers,
  Suppliers,
  Categories,
  Products,
  SubProducts,
  Sizes,
  IceLevels,
  SweetLevels,
  ProductSizes,
  ProductIceLevels,
  ProductSweetLevels,
])
class CleanupDao extends DatabaseAccessor<AppDatabase>
    with _$CleanupDaoMixin {
  CleanupDao(super.db);

  // ── Orders ────────────────────────────────────────────────────────────────

  Future<void> clearAllOrders() => transaction(() async {
        await delete(orderItemToppings).go();
        await delete(orderItems).go();
        await delete(orders).go();
      });

  Future<void> clearOrdersOlderThan(DateTime cutoff) => transaction(() async {
        // Collect ids of orders older than cutoff
        final oldOrders = await (select(orders)
              ..where((o) => o.createdAt.isSmallerThanValue(cutoff)))
            .map((o) => o.id)
            .get();

        if (oldOrders.isEmpty) return;

        // Delete toppings for those order items
        final oldItems = await (select(orderItems)
              ..where((i) => i.orderId.isIn(oldOrders)))
            .map((i) => i.id)
            .get();

        if (oldItems.isNotEmpty) {
          await (delete(orderItemToppings)
                ..where((t) => t.orderItemId.isIn(oldItems)))
              .go();
        }

        await (delete(orderItems)..where((i) => i.orderId.isIn(oldOrders)))
            .go();
        await (delete(orders)
              ..where((o) => o.createdAt.isSmallerThanValue(cutoff)))
            .go();
      });

  // ── Customers ─────────────────────────────────────────────────────────────

  Future<void> clearCustomers() => delete(customers).go();

  // ── Suppliers ─────────────────────────────────────────────────────────────

  Future<void> clearSuppliers() => delete(suppliers).go();

  // ── Catalog ───────────────────────────────────────────────────────────────

  Future<void> clearCatalog() => transaction(() async {
        await delete(productSizes).go();
        await delete(productIceLevels).go();
        await delete(productSweetLevels).go();
        await delete(subProducts).go();
        await delete(products).go();
        await delete(categories).go();
      });

  // ── Options (reset to seeded defaults) ────────────────────────────────────

  Future<void> resetOptions() => transaction(() async {
        await delete(productSizes).go();
        await delete(productIceLevels).go();
        await delete(productSweetLevels).go();
        await delete(sizes).go();
        await delete(iceLevels).go();
        await delete(sweetLevels).go();
        await db.seedOptions();
      });

  // ── Factory Reset ─────────────────────────────────────────────────────────

  Future<void> factoryReset() => transaction(() async {
        await delete(orderItemToppings).go();
        await delete(orderItems).go();
        await delete(orders).go();
        await delete(customers).go();
        await delete(suppliers).go();
        await delete(productSizes).go();
        await delete(productIceLevels).go();
        await delete(productSweetLevels).go();
        await delete(subProducts).go();
        await delete(products).go();
        await delete(categories).go();
        await delete(sizes).go();
        await delete(iceLevels).go();
        await delete(sweetLevels).go();
        await db.seedOptions();
      });
}
