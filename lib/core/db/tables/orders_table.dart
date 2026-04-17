import 'package:drift/drift.dart';
import 'customers_table.dart';

/// Status values: pending, completed, cancelled
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId =>
      integer().nullable().references(Customers, #id)();
  RealColumn get totalAmount => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
