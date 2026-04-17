import 'package:drift/drift.dart';
import 'products_table.dart';
import 'ice_levels_table.dart';

class ProductIceLevels extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get iceLevelId => integer().references(IceLevels, #id)();

  @override
  Set<Column> get primaryKey => {productId, iceLevelId};
}
