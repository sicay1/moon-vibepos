import 'package:drift/drift.dart';
import 'categories_table.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  RealColumn get price => real().withDefault(const Constant(0))();
  TextColumn get avatarPath => text().nullable()();
  /// JSON-encoded list of image paths
  TextColumn get images => text().withDefault(const Constant('[]'))();
  /// JSON-encoded list of ingredient strings
  TextColumn get ingredients => text().withDefault(const Constant('[]'))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
