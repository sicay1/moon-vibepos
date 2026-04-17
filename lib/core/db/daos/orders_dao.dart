import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/orders_table.dart';
import '../tables/order_items_table.dart';
import '../tables/order_item_toppings_table.dart';

part 'orders_dao.g.dart';

class OrderWithItems {
  final Order order;
  final List<OrderItemWithToppings> items;
  const OrderWithItems({required this.order, required this.items});
}

class OrderItemWithToppings {
  final OrderItem item;
  final List<OrderItemTopping> toppings;
  const OrderItemWithToppings({required this.item, required this.toppings});
}

@DriftAccessor(tables: [Orders, OrderItems, OrderItemToppings])
class OrdersDao extends DatabaseAccessor<AppDatabase>
    with _$OrdersDaoMixin {
  OrdersDao(super.db);

  Stream<List<Order>> watchAll() {
    return (select(orders)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Order>> watchByStatus(String status) {
    return (select(orders)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<Order>> getAll() {
    return (select(orders)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<Order?> getById(int id) {
    return (select(orders)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<OrderItem>> getItemsByOrder(int orderId) {
    return (select(orderItems)
          ..where((t) => t.orderId.equals(orderId)))
        .get();
  }

  Future<List<OrderItemTopping>> getToppingsByItem(int orderItemId) {
    return (select(orderItemToppings)
          ..where((t) => t.orderItemId.equals(orderItemId)))
        .get();
  }

  Future<OrderWithItems?> getOrderWithItems(int id) async {
    final order = await getById(id);
    if (order == null) return null;
    final items = await getItemsByOrder(id);
    final itemsWithToppings = await Future.wait(
      items.map((item) async {
        final toppings = await getToppingsByItem(item.id);
        return OrderItemWithToppings(item: item, toppings: toppings);
      }),
    );
    return OrderWithItems(order: order, items: itemsWithToppings);
  }

  /// Inserts a full order with items and toppings in a single transaction.
  Future<int> insertFullOrder({
    required OrdersCompanion order,
    required List<({OrderItemsCompanion item, List<OrderItemToppingsCompanion> toppings})> lines,
  }) async {
    return transaction(() async {
      final orderId = await into(orders).insert(order);
      for (final line in lines) {
        final itemId = await into(orderItems)
            .insert(line.item.copyWith(orderId: Value(orderId)));
        for (final topping in line.toppings) {
          await into(orderItemToppings)
              .insert(topping.copyWith(orderItemId: Value(itemId)));
        }
      }
      return orderId;
    });
  }

  Future<bool> updateStatus(int id, String status) async {
    final rows = await (update(orders)..where((t) => t.id.equals(id)))
        .write(OrdersCompanion(status: Value(status)));
    return rows > 0;
  }

  // ── Dashboard queries ──────────────────────────────────────────────────────

  Future<double> revenueForRange(DateTime from, DateTime to) async {
    final query = customSelect(
      'SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders '
      'WHERE status = ? AND created_at >= ? AND created_at < ?',
      variables: [
        Variable.withString('completed'),
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    );
    final result = await query.getSingle();
    return result.read<double>('total');
  }

  Future<int> orderCountForRange(DateTime from, DateTime to) async {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM orders WHERE created_at >= ? AND created_at < ?',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    );
    final result = await query.getSingle();
    return result.read<int>('cnt');
  }

  /// Returns daily revenue for the last [days] days (most recent last).
  Future<List<({DateTime date, double revenue})>> dailyRevenue(int days) async {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days - 1))
        .toUtc()
        .millisecondsSinceEpoch ~/
        1000;
    final query = customSelect(
      'SELECT date(created_at, \'unixepoch\') AS day, COALESCE(SUM(total_amount), 0) AS revenue '
      'FROM orders WHERE status = ? AND created_at >= ? '
      'GROUP BY day ORDER BY day ASC',
      variables: [
        Variable.withString('completed'),
        Variable.withInt(cutoff),
      ],
      readsFrom: {orders},
    );
    final rows = await query.get();
    return rows.map((r) {
      return (
        date: DateTime.parse(r.read<String>('day')),
        revenue: r.read<double>('revenue'),
      );
    }).toList();
  }

  /// Top N customers by total spend this month.
  Future<List<({int customerId, double total})>> topCustomers(int n) async {
    final now = DateTime.now().toUtc();
    final startOfMonth = DateTime.utc(now.year, now.month, 1)
        .millisecondsSinceEpoch ~/
        1000;
    final query = customSelect(
      'SELECT customer_id, COALESCE(SUM(total_amount), 0) AS total FROM orders '
      "WHERE status = 'completed' AND customer_id IS NOT NULL "
      'AND created_at >= ? '
      'GROUP BY customer_id ORDER BY total DESC LIMIT ?',
      variables: [Variable.withInt(startOfMonth), Variable.withInt(n)],
      readsFrom: {orders},
    );
    final rows = await query.get();
    return rows.map((r) {
      return (
        customerId: r.read<int>('customer_id'),
        total: r.read<double>('total'),
      );
    }).toList();
  }
}
