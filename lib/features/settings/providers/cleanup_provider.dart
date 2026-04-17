import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/db/daos/cleanup_dao.dart';
import '../../../core/providers/database_provider.dart';

part 'cleanup_provider.g.dart';

@riverpod
CleanupDao cleanupDao(CleanupDaoRef ref) {
  return ref.watch(appDatabaseProvider).cleanupDao;
}

@riverpod
class CleanupNotifier extends _$CleanupNotifier {
  @override
  void build() {}

  Future<void> clearAllOrders() =>
      ref.read(cleanupDaoProvider).clearAllOrders();

  Future<void> clearOrdersOlderThan(DateTime cutoff) =>
      ref.read(cleanupDaoProvider).clearOrdersOlderThan(cutoff);

  Future<void> clearCustomers() =>
      ref.read(cleanupDaoProvider).clearCustomers();

  Future<void> clearSuppliers() =>
      ref.read(cleanupDaoProvider).clearSuppliers();

  Future<void> clearCatalog() =>
      ref.read(cleanupDaoProvider).clearCatalog();

  Future<void> resetOptions() =>
      ref.read(cleanupDaoProvider).resetOptions();

  Future<void> factoryReset() =>
      ref.read(cleanupDaoProvider).factoryReset();
}
