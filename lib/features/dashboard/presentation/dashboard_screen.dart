import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../../../core/shared/widgets/stat_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../contacts/customers/providers/customers_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardStatsProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.todaySales,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: l10n.revenue,
                      value: currencyFmt.format(stats.todayRevenue),
                      icon: Icons.attach_money,
                      backgroundColor: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      label: l10n.totalOrders,
                      value: '${stats.todayOrders}',
                      icon: Icons.receipt_long,
                      backgroundColor: AppColors.warmGray,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 16),
          
              // Text(l10n.monthSales,
              //     style: Theme.of(context)
              //         .textTheme
              //         .titleMedium
              //         ?.copyWith(fontWeight: FontWeight.w700)),
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     Expanded(
              //       child: StatCard(
              //         label: l10n.revenue,
              //         value: currencyFmt.format(stats.monthRevenue),
              //         icon: Icons.calendar_month,
              //         backgroundColor: AppColors.warmGray,
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: StatCard(
              //         label: l10n.totalOrders,
              //         value: '${stats.monthOrders}',
              //         icon: Icons.bar_chart,
              //         backgroundColor: AppColors.warmGray,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              _WeeklyChart(stats: stats),
              const SizedBox(height: 24),
              _TopCustomersSection(
                topCustomers: stats.topCustomers,
                currencyFmt: currencyFmt,
              ),
            ],
          ),
        ),
      );
  }
}

class _WeeklyChart extends StatelessWidget {
  final DashboardStats stats;
  const _WeeklyChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.dailyRevenue.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencyFmt = NumberFormat.compact(locale: 'vi_VN');
    final maxRevenue = stats.dailyRevenue
        .map((d) => d.revenue)
        .fold<double>(1, (a, b) => a > b ? a : b);
    // Round up to a nice interval
    final yMax = (maxRevenue * 1.2).ceilToDouble();
    final interval = yMax > 0 ? (yMax / 4).ceilToDouble() : 1.0;

    final spots = <FlSpot>[];
    for (var i = 0; i < stats.dailyRevenue.length; i++) {
      spots.add(FlSpot(i.toDouble(), stats.dailyRevenue[i].revenue));
    }

    const darkBg = Color(0xFF1E2A38);
    const lineColor = Color(0xFF4FD1C5);
    const gridColor = Color(0xFF2D3D4F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context).last7DaysRevenue,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(4, 20, 16, 8),
          // decoration: BoxDecoration(
          //   color: darkBg,
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: yMax,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: gridColor,
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: interval,
                    getTitlesWidget: (value, _) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        currencyFmt.format(value),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= stats.dailyRevenue.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          DateFormat('E')
                              .format(stats.dailyRevenue[idx].date)
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map((s) => LineTooltipItem(
                            NumberFormat.currency(
                                    locale: 'vi_VN', symbol: '₫')
                                .format(s.y),
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ))
                      .toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: lineColor,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) =>
                        FlDotCirclePainter(
                      radius: 4,
                      color: lineColor,
                      strokeWidth: 2,
                      strokeColor: darkBg,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withAlpha(80),
                        lineColor.withAlpha(10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopCustomersSection extends ConsumerWidget {
  final List<({int customerId, double total})> topCustomers;
  final NumberFormat currencyFmt;
  const _TopCustomersSection(
      {required this.topCustomers, required this.currencyFmt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (topCustomers.isEmpty) return const SizedBox.shrink();

    final customersAsync = ref.watch(customersStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context).topCustomersThisMonth,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        customersAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => const SizedBox.shrink(),
          data: (customers) {
            return Column(
              children: topCustomers.map((tc) {
                final customer = customers
                    .where((c) => c.id == tc.customerId)
                    .firstOrNull;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.pink,
                    child: Text(
                      customer?.name.isNotEmpty == true
                          ? customer!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(customer?.name ?? 'Customer #${tc.customerId}'),
                  subtitle: Text(customer?.phone ?? ''),
                  trailing: Text(
                    currencyFmt.format(tc.total),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
