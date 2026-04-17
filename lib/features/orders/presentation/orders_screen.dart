import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import 'create_order_screen.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _filterStatus = 'all';

  Color _statusColor(String status) => switch (status) {
        'completed' => AppColors.completed,
        'cancelled' => AppColors.cancelled,
        _ => AppColors.pending,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ordersAsync = ref.watch(ordersStreamProvider);
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFmt = DateFormat('dd/MM HH:mm');

    return Scaffold(
      body: Column(
        children: [
          // ── Filter bar ─────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    label: 'All',
                    selected: _filterStatus == 'all',
                    onTap: () => setState(() => _filterStatus = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.orderStatusPending,
                    selected: _filterStatus == 'pending',
                    onTap: () => setState(() => _filterStatus = 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.orderStatusCompleted,
                    selected: _filterStatus == 'completed',
                    onTap: () => setState(() => _filterStatus = 'completed'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.orderStatusCancelled,
                    selected: _filterStatus == 'cancelled',
                    onTap: () => setState(() => _filterStatus = 'cancelled'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // ── Orders list ─────────────────────────────────────────────────
          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (orders) {
                final filtered = _filterStatus == 'all'
                    ? orders
                    : orders.where((o) => o.status == _filterStatus).toList();
                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                      message: l10n.emptyList,
                      icon: Icons.receipt_long_outlined);
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final order = filtered[i];
                    return Card(
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailScreen(orderId: order.id)),
                        ),
                        title: Row(
                          children: [
                            Text('#${order.id}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    _statusColor(order.status).withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  color: _statusColor(order.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(dateFmt.format(order.createdAt.toLocal())),
                            const Spacer(),
                            Text(
                              currencyFmt.format(order.totalAmount),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'ordersFab',
        shape: const StadiumBorder(),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.newOrder),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _StatusChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
