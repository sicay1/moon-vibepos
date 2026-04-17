import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/sub_products_provider.dart';
import '../../products/providers/products_provider.dart';
import 'sub_product_form_screen.dart';

class SubProductsScreen extends ConsumerWidget {
  const SubProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subProductsAsync = ref.watch(subProductsStreamProvider);
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      body: subProductsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (subs) {
          if (subs.isEmpty) {
            return EmptyStateWidget(
                message: l10n.emptyList, icon: Icons.bubble_chart_outlined);
          }
          return productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
            data: (products) => ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: subs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final sub = subs[i];
                final parent = products
                    .where((p) => p.id == sub.productId)
                    .firstOrNull;
                return Card(
                  child: ListTile(
                    leading: PlaceholderAvatar(
                      imagePath: sub.avatarPath,
                      initials: sub.name,
                      backgroundColor: AppColors.lightGreen,
                    ),
                    title: Text(sub.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${sub.price.toStringAsFixed(0)}₫'),
                        if (parent != null)
                          Text(parent.name,
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                      ],
                    ),
                    isThreeLine: parent != null,
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
                                    SubProductFormScreen(subProduct: sub)),
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
                                  .read(subProductsNotifierProvider.notifier)
                                  .delete(sub.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'subProductsFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubProductFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
