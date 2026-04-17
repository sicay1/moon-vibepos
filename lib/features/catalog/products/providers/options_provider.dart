import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'options_provider.g.dart';

// ── Global streams ────────────────────────────────────────────────────────────

@riverpod
Stream<List<Size>> sizesStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchAllSizes();
}

@riverpod
Stream<List<IceLevel>> iceLevelsStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchAllIceLevels();
}

@riverpod
Stream<List<SweetLevel>> sweetLevelsStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchAllSweetLevels();
}

// ── Per-product streams ───────────────────────────────────────────────────────

@riverpod
Stream<List<Size>> productSizesStream(Ref ref, int productId) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchSizesForProduct(productId);
}

@riverpod
Stream<List<IceLevel>> productIceLevelsStream(Ref ref, int productId) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchIceLevelsForProduct(productId);
}

@riverpod
Stream<List<SweetLevel>> productSweetLevelsStream(Ref ref, int productId) {
  final db = ref.watch(appDatabaseProvider);
  return db.optionsDao.watchSweetLevelsForProduct(productId);
}

// ── Notifiers ─────────────────────────────────────────────────────────────────

@riverpod
class SizesNotifier extends _$SizesNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<void> add(String label, double price) async {
    final allSizes = await _db.optionsDao.watchAllSizes().first;
    final maxOrder =
        allSizes.fold<int>(0, (m, s) => s.sortOrder > m ? s.sortOrder : m);
    await _db.optionsDao.insertSize(SizesCompanion.insert(
      label: label,
      price: Value(price),
      sortOrder: Value(maxOrder + 1),
    ));
  }

  Future<void> updatePrice(int id, double price) =>
      _db.optionsDao.updateSizePrice(id, price);

  Future<void> delete(int id) => _db.optionsDao.deleteSize(id);
}

@riverpod
class IceLevelsNotifier extends _$IceLevelsNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<void> add(String label) async {
    final all = await _db.optionsDao.watchAllIceLevels().first;
    final maxOrder =
        all.fold<int>(0, (m, s) => s.sortOrder > m ? s.sortOrder : m);
    await _db.optionsDao.insertIceLevel(IceLevelsCompanion.insert(
      label: label,
      sortOrder: Value(maxOrder + 1),
    ));
  }

  Future<void> delete(int id) => _db.optionsDao.deleteIceLevel(id);
}

@riverpod
class SweetLevelsNotifier extends _$SweetLevelsNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<void> add(String label) async {
    final all = await _db.optionsDao.watchAllSweetLevels().first;
    final maxOrder =
        all.fold<int>(0, (m, s) => s.sortOrder > m ? s.sortOrder : m);
    await _db.optionsDao.insertSweetLevel(SweetLevelsCompanion.insert(
      label: label,
      sortOrder: Value(maxOrder + 1),
    ));
  }

  Future<void> delete(int id) => _db.optionsDao.deleteSweetLevel(id);
}

@riverpod
class ProductOptionsNotifier extends _$ProductOptionsNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<void> toggleSize(int productId, int sizeId, bool enabled) =>
      _db.optionsDao.setProductSize(productId, sizeId, enabled);

  Future<void> toggleIceLevel(int productId, int iceLevelId, bool enabled) =>
      _db.optionsDao.setProductIceLevel(productId, iceLevelId, enabled);

  Future<void> toggleSweetLevel(int productId, int sweetLevelId, bool enabled) =>
      _db.optionsDao.setProductSweetLevel(productId, sweetLevelId, enabled);
}
