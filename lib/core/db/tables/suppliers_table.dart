import 'package:drift/drift.dart';

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get googleMapUrl => text().nullable()();
  TextColumn get priceNote => text().nullable()();
  TextColumn get notes => text().nullable()();
}
