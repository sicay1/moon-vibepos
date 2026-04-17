import 'package:drift/drift.dart';
import 'products_table.dart';
import 'sweet_levels_table.dart';

class ProductSweetLevels extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get sweetLevelId => integer().references(SweetLevels, #id)();

  @override
  Set<Column> get primaryKey => {productId, sweetLevelId};
}
