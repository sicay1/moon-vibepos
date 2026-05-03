import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'products_provider.g.dart';

@riverpod
Stream<List<Product>> productsStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.productsDao.watchAll();
}

@riverpod
Stream<Product?> productStream(Ref ref, int id) {
  final db = ref.watch(appDatabaseProvider);
  return db.productsDao.watchById(id);
}

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> add({
    required String name,
    required double price,
    int? categoryId,
    String? avatarPath,
    List<String> images = const [],
    List<String> ingredients = const [],
    String? description,
  }) {
    return _db.productsDao.insertProduct(
      ProductsCompanion.insert(
        name: name,
        price: Value(price),
        categoryId: Value(categoryId),
        avatarPath: Value(avatarPath),
        images: Value(jsonEncode(images)),
        ingredients: Value(jsonEncode(ingredients)),
        description: Value(description),
      ),
    );
  }

  Future<bool> update(Product product) {
    return _db.productsDao.updateProduct(
      ProductsCompanion(
        id: Value(product.id),
        name: Value(product.name),
        price: Value(product.price),
        categoryId: Value(product.categoryId),
        avatarPath: Value(product.avatarPath),
        images: Value(product.images),
        ingredients: Value(product.ingredients),
        description: Value(product.description),
      ),
    );
  }

  Future<int> delete(int id) {
    return _db.productsDao.deleteProduct(id);
  }
}
