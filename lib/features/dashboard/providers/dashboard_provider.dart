import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';

part 'dashboard_provider.g.dart';

class DashboardStats {
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final int todayOrders;
  final int weekOrders;
  final int monthOrders;
  final List<({DateTime date, double revenue})> dailyRevenue;
  final List<({int customerId, double total})> topCustomers;

  const DashboardStats({
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.todayOrders,
    required this.weekOrders,
    required this.monthOrders,
    required this.dailyRevenue,
    required this.topCustomers,
  });
}

@riverpod
Future<DashboardStats> dashboardStats(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1));
  final monthStart = DateTime(now.year, now.month, 1);
  final tomorrow = todayStart.add(const Duration(days: 1));
  final nextWeek = weekStart.add(const Duration(days: 7));
  final nextMonth = DateTime(now.year, now.month + 1, 1);

  final results = await Future.wait([
    db.ordersDao.revenueForRange(todayStart, tomorrow),
    db.ordersDao.revenueForRange(weekStart, nextWeek),
    db.ordersDao.revenueForRange(monthStart, nextMonth),
    db.ordersDao.orderCountForRange(todayStart, tomorrow),
    db.ordersDao.orderCountForRange(weekStart, nextWeek),
    db.ordersDao.orderCountForRange(monthStart, nextMonth),
  ]);

  final daily = await db.ordersDao.dailyRevenue(7);
  final topCusts = await db.ordersDao.topCustomers(5);

  return DashboardStats(
    todayRevenue: results[0] as double,
    weekRevenue: results[1] as double,
    monthRevenue: results[2] as double,
    todayOrders: results[3] as int,
    weekOrders: results[4] as int,
    monthOrders: results[5] as int,
    dailyRevenue: daily,
    topCustomers: topCusts,
  );
}
