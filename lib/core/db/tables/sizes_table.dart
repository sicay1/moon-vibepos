import 'package:drift/drift.dart';

class Sizes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text().withLength(min: 1, max: 100)();
  RealColumn get price => real().named('price_delta').withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
