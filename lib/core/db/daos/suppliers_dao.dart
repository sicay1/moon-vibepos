import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/suppliers_table.dart';

part 'suppliers_dao.g.dart';

@DriftAccessor(tables: [Suppliers])
class SuppliersDao extends DatabaseAccessor<AppDatabase>
    with _$SuppliersDaoMixin {
  SuppliersDao(super.db);

  Stream<List<Supplier>> watchAll() {
    return (select(suppliers)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<Supplier>> getAll() {
    return (select(suppliers)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Supplier?> getById(int id) {
    return (select(suppliers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertSupplier(SuppliersCompanion entry) {
    return into(suppliers).insert(entry);
  }

  Future<bool> updateSupplier(SuppliersCompanion entry) {
    return update(suppliers).replace(entry);
  }

  Future<int> deleteSupplier(int id) {
    return (delete(suppliers)..where((t) => t.id.equals(id))).go();
  }
}
