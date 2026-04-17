import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/products_provider.dart';
import 'product_form_screen.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) {
          if (products.isEmpty) {
            return EmptyStateWidget(
                message: l10n.emptyList, icon: Icons.local_drink_outlined);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: p),
                    ),
                  ),
                  leading: PlaceholderAvatar(
                    imagePath: p.avatarPath,
                    initials: p.name,
                    backgroundColor: AppColors.pink,
                  ),
                  title: Text(p.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${p.price.toStringAsFixed(0)}₫'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.secondary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProductFormScreen(product: p)),
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
                                .read(productsNotifierProvider.notifier)
                                .delete(p.id);
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
        heroTag: 'productsFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
