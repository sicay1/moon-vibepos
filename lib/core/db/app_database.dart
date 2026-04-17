import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/categories_table.dart';
import 'tables/customers_table.dart';
import 'tables/order_item_toppings_table.dart';
import 'tables/order_items_table.dart';
import 'tables/orders_table.dart';
import 'tables/products_table.dart';
import 'tables/sub_products_table.dart';
import 'tables/suppliers_table.dart';
import 'tables/sizes_table.dart';
import 'tables/ice_levels_table.dart';
import 'tables/sweet_levels_table.dart';
import 'tables/product_sizes_table.dart';
import 'tables/product_ice_levels_table.dart';
import 'tables/product_sweet_levels_table.dart';

import 'daos/categories_dao.dart';
import 'daos/customers_dao.dart';
import 'daos/orders_dao.dart';
import 'daos/products_dao.dart';
import 'daos/sub_products_dao.dart';
import 'daos/suppliers_dao.dart';
import 'daos/options_dao.dart';
import 'daos/cleanup_dao.dart';
import 'daos/backup_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
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
  ],
  daos: [
    CategoriesDao,
    ProductsDao,
    SubProductsDao,
    CustomersDao,
    SuppliersDao,
    OrdersDao,
    OptionsDao,
    CleanupDao,
    BackupDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await seedOptions();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Make customers.phone nullable (recreates table preserving data)
          await m.alterTable(TableMigration(customers));
          // Add note column to order_items
          await m.addColumn(orderItems, orderItems.note);
        }
        if (from < 3) {
          // Create 6 new option tables
          await m.createTable(sizes);
          await m.createTable(iceLevels);
          await m.createTable(sweetLevels);
          await m.createTable(productSizes);
          await m.createTable(productIceLevels);
          await m.createTable(productSweetLevels);
          // Add 4 new columns to order_items
          await m.addColumn(orderItems, orderItems.sizeLabel);
          await m.addColumn(orderItems, orderItems.sizePrice);
          await m.addColumn(orderItems, orderItems.iceLabel);
          await m.addColumn(orderItems, orderItems.sweetLabel);
          // Seed default options
          await seedOptions();
        }
      },
    );
  }

  Future<void> seedOptions() async {
    await batch((b) {
      b.insertAll(sizes, [
        SizesCompanion.insert(
            label: 'Small (500ml)',
            sortOrder: const Value(1)),
        SizesCompanion.insert(
            label: 'Normal (700ml)',
            sortOrder: const Value(2)),
        SizesCompanion.insert(
            label: 'Large (1L)',
            sortOrder: const Value(3)),
      ]);
      b.insertAll(iceLevels, [
        IceLevelsCompanion.insert(label: 'No Ice', sortOrder: const Value(1)),
        IceLevelsCompanion.insert(label: 'Less Ice', sortOrder: const Value(2)),
        IceLevelsCompanion.insert(label: 'Plus Ice', sortOrder: const Value(3)),
      ]);
      b.insertAll(sweetLevels, [
        SweetLevelsCompanion.insert(
            label: 'No Sweet', sortOrder: const Value(1)),
        SweetLevelsCompanion.insert(
            label: 'Less Sweet', sortOrder: const Value(2)),
        SweetLevelsCompanion.insert(
            label: 'Normal', sortOrder: const Value(3)),
        SweetLevelsCompanion.insert(
            label: 'Add Sweet', sortOrder: const Value(4)),
      ]);
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'moon_pos_vibe');
  }
}

