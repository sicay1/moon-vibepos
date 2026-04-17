import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/customers_table.dart';

part 'customers_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<AppDatabase>
    with _$CustomersDaoMixin {
  CustomersDao(super.db);

  Stream<List<Customer>> watchAll() {
    return (select(customers)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<Customer>> getAll() {
    return (select(customers)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Customer?> getById(int id) {
    return (select(customers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertCustomer(CustomersCompanion entry) {
    return into(customers).insert(entry);
  }

  Future<bool> updateCustomer(CustomersCompanion entry) {
    return update(customers).replace(entry);
  }

  Future<int> deleteCustomer(int id) {
    return (delete(customers)..where((t) => t.id.equals(id))).go();
  }
}
