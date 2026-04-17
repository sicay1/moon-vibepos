import 'package:drift/drift.dart';
import 'products_table.dart';

class SubProducts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  RealColumn get price => real().withDefault(const Constant(0))();
  TextColumn get avatarPath => text().nullable()();
}
