import 'package:drift/drift.dart';
import 'order_items_table.dart';

class OrderItemToppings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderItemId => integer().references(OrderItems, #id)();
  IntColumn get subProductId => integer()();
  TextColumn get subProductName => text()();
  RealColumn get unitPrice => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
