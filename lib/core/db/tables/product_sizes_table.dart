import 'package:drift/drift.dart';
import 'products_table.dart';
import 'sizes_table.dart';

class ProductSizes extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get sizeId => integer().references(Sizes, #id)();

  @override
  Set<Column> get primaryKey => {productId, sizeId};
}
