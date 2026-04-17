import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  TextColumn get phone => text().withLength(min: 1, max: 20).nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get facebookContact => text().nullable()();
  TextColumn get zaloContact => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
