import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'sub_products_provider.g.dart';

@riverpod
Stream<List<SubProduct>> subProductsStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.subProductsDao.watchAll();
}

@riverpod
class SubProductsNotifier extends _$SubProductsNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> add({
    required int productId,
    required String name,
    required double price,
    String? avatarPath,
  }) {
    return _db.subProductsDao.insertSubProduct(
      SubProductsCompanion.insert(
        productId: productId,
        name: name,
        price: Value(price),
        avatarPath: Value(avatarPath),
      ),
    );
  }

  Future<bool> update(SubProduct sub) {
    return _db.subProductsDao.updateSubProduct(
      SubProductsCompanion(
        id: Value(sub.id),
        productId: Value(sub.productId),
        name: Value(sub.name),
        price: Value(sub.price),
        avatarPath: Value(sub.avatarPath),
      ),
    );
  }

  Future<int> delete(int id) {
    return _db.subProductsDao.deleteSubProduct(id);
  }
}
