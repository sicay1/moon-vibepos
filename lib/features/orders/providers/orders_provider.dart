import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/daos/orders_dao.dart';
import '../../../core/providers/database_provider.dart';

part 'orders_provider.g.dart';

@riverpod
Stream<List<Order>> ordersStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.ordersDao.watchAll();
}

@riverpod
Future<OrderWithItems?> orderDetail(Ref ref, int orderId) {
  final db = ref.watch(appDatabaseProvider);
  return db.ordersDao.getOrderWithItems(orderId);
}

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> createOrder({
    int? customerId,
    required double totalAmount,
    double discount = 0,
    String? note,
    required List<({OrderItemsCompanion item, List<OrderItemToppingsCompanion> toppings})> lines,
  }) {
    return _db.ordersDao.insertFullOrder(
      order: OrdersCompanion.insert(
        customerId: Value(customerId),
        totalAmount: Value(totalAmount),
        discount: Value(discount),
        note: Value(note),
        status: const Value('pending'),
      ),
      lines: lines,
    );
  }

  Future<bool> updateStatus(int id, String status) {
    return _db.ordersDao.updateStatus(id, status);
  }
}
