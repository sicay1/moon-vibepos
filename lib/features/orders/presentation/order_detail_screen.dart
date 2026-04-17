import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';
import '../../../core/theme/app_colors.dart';

class OrderDetailScreen extends ConsumerWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  Color _statusColor(String status) => switch (status) {
        'completed' => AppColors.completed,
        'cancelled' => AppColors.cancelled,
        _ => AppColors.pending,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orderAsync = ref.watch(orderDetailProvider(orderId));
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (orderWithItems) {
          if (orderWithItems == null) {
            return const Center(child: Text('Order not found'));
          }
          final order = orderWithItems.order;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status + Date row
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(order.status),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(dateFmt.format(order.createdAt.toLocal()),
                      style:
                          const TextStyle(color: AppColors.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 16),
              // Items
              ...orderWithItems.items.map((itemWithToppings) {
                final item = itemWithToppings.item;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(item.productName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text('x${item.quantity}'),
                            const SizedBox(width: 8),
                            Text(currencyFmt
                                .format(item.unitPrice * item.quantity)),
                          ],
                        ),
                        if (item.sizeLabel != null ||
                            item.iceLabel != null ||
                            item.sweetLabel != null) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              if (item.sizeLabel != null)
                                _OptionBadge(
                                    icon: Icons.local_drink_outlined,
                                    label: item.sizePrice != null &&
                                            item.sizePrice! > 0
                                        ? '${item.sizeLabel} (${currencyFmt.format(item.sizePrice)})'
                                        : item.sizeLabel!,
                                    color: const Color(0xFFE07A98)),
                              if (item.iceLabel != null)
                                _OptionBadge(
                                    icon: Icons.ac_unit,
                                    label: item.iceLabel!,
                                    color: Colors.lightBlue),
                              if (item.sweetLabel != null)
                                _OptionBadge(
                                    icon: Icons.cake_outlined,
                                    label: item.sweetLabel!,
                                    color: Colors.amber.shade700),
                            ],
                          ),
                        ],
                        ...itemWithToppings.toppings.map((t) => Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Row(
                                children: [
                                  Text('+ ${t.subProductName}',
                                      style: const TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 13)),
                                  const Spacer(),
                                  Text(
                                      '${currencyFmt.format(t.unitPrice)} x${t.quantity}',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            )),
                        if (item.note != null && item.note!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.note_outlined,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(item.note!,
                                    style: const TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              if (order.note != null && order.note!.isNotEmpty) ...[
                Text('Note: ${order.note!}',
                    style:
                        const TextStyle(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 8),
              ],
              // Totals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount'),
                  Text('-${currencyFmt.format(order.discount)}'),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.orderTotal,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  Text(currencyFmt.format(order.totalAmount),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 24),
              // Status actions
              if (order.status == 'pending') ...[
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(ordersNotifierProvider.notifier)
                        .updateStatus(orderId, 'completed');
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(l10n.orderStatusCompleted),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error)),
                  onPressed: () async {
                    await ref
                        .read(ordersNotifierProvider.notifier)
                        .updateStatus(orderId, 'cancelled');
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(l10n.orderStatusCancelled),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OptionBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _OptionBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}
