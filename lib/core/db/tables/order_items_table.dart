import 'package:drift/drift.dart';
import 'orders_table.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer()();
  TextColumn get productName => text()();
  RealColumn get unitPrice => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
  TextColumn get sizeLabel => text().nullable()();
  RealColumn get sizePrice => real().named('size_price_delta').nullable()();
  TextColumn get iceLabel => text().nullable()();
  TextColumn get sweetLabel => text().nullable()();
}
