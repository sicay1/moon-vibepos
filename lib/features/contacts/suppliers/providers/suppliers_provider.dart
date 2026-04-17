import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'suppliers_provider.g.dart';

@riverpod
Stream<List<Supplier>> suppliersStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.suppliersDao.watchAll();
}

@riverpod
class SuppliersNotifier extends _$SuppliersNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> add({
    required String name,
    String address = '',
    String? googleMapUrl,
    String? priceNote,
    String? notes,
  }) {
    return _db.suppliersDao.insertSupplier(
      SuppliersCompanion.insert(
        name: name,
        address: Value(address),
        googleMapUrl: Value(googleMapUrl),
        priceNote: Value(priceNote),
        notes: Value(notes),
      ),
    );
  }

  Future<bool> update(Supplier supplier) {
    return _db.suppliersDao.updateSupplier(
      SuppliersCompanion(
        id: Value(supplier.id),
        name: Value(supplier.name),
        address: Value(supplier.address),
        googleMapUrl: Value(supplier.googleMapUrl),
        priceNote: Value(supplier.priceNote),
        notes: Value(supplier.notes),
      ),
    );
  }

  Future<int> delete(int id) {
    return _db.suppliersDao.deleteSupplier(id);
  }
}
