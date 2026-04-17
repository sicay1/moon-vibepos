import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sub_products_table.dart';

part 'sub_products_dao.g.dart';

@DriftAccessor(tables: [SubProducts])
class SubProductsDao extends DatabaseAccessor<AppDatabase>
    with _$SubProductsDaoMixin {
  SubProductsDao(super.db);

  Stream<List<SubProduct>> watchAll() {
    return (select(subProducts)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<SubProduct>> watchByProduct(int productId) {
    return (select(subProducts)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<SubProduct>> getAll() {
    return (select(subProducts)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<List<SubProduct>> getByProduct(int productId) {
    return (select(subProducts)
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Future<int> insertSubProduct(SubProductsCompanion entry) {
    return into(subProducts).insert(entry);
  }

  Future<bool> updateSubProduct(SubProductsCompanion entry) {
    return update(subProducts).replace(entry);
  }

  Future<int> deleteSubProduct(int id) {
    return (delete(subProducts)..where((t) => t.id.equals(id))).go();
  }
}
