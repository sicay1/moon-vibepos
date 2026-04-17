import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/customers_provider.dart';
import 'customer_form_screen.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customersAsync = ref.watch(customersStreamProvider);

    return Scaffold(
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (customers) {
          if (customers.isEmpty) {
            return EmptyStateWidget(
                message: l10n.emptyList, icon: Icons.people_outline);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: customers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final c = customers[i];
              return Card(
                child: ListTile(
                  leading: PlaceholderAvatar(
                    imagePath: c.avatarPath,
                    initials: c.name,
                    backgroundColor: AppColors.pink,
                  ),
                  title: Text(c.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c.phone ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.secondary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CustomerFormScreen(customer: c)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        onPressed: () async {
                          final confirmed = await showDeleteConfirmDialog(
                              context,
                              title: l10n.deleteConfirmTitle,
                              message: l10n.deleteConfirmMessage);
                          if (confirmed == true) {
                            await ref
                                .read(customersNotifierProvider.notifier)
                                .delete(c.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'customersFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
