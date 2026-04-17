import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'categories_provider.g.dart';

@riverpod
Stream<List<Category>> categoriesStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoriesDao.watchAll();
}

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> add(String name, {String? imagePath, String? description}) {
    return _db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: name,
        imagePath: Value(imagePath),
        description: Value(description),
      ),
    );
  }

  Future<bool> update(Category category) {
    return _db.categoriesDao.updateCategory(
      CategoriesCompanion(
        id: Value(category.id),
        name: Value(category.name),
        imagePath: Value(category.imagePath),
        description: Value(category.description),
      ),
    );
  }

  Future<int> delete(int id) {
    return _db.categoriesDao.deleteCategory(id);
  }
}
