import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../products/providers/products_provider.dart';
import '../../products/presentation/product_detail_screen.dart';
import 'category_form_screen.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CategoryFormScreen(category: category)),
            ),
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (allProducts) {
          final inCategory = allProducts
              .where((p) => p.categoryId == category.id)
              .toList();
          final unassigned = allProducts
              .where((p) => p.categoryId != category.id)
              .toList();

          return CustomScrollView(
            slivers: [
              // Category info card
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlaceholderAvatar(
                          imagePath: category.imagePath,
                          initials: category.name,
                          radius: 36,
                          backgroundColor: AppColors.lightBlue,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (category.description != null &&
                                  category.description!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  category.description!,
                                  style: const TextStyle(
                                      color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.tabProducts,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.add),
                        onPressed: unassigned.isEmpty
                            ? null
                            : () => _showAddProductSheet(
                                context, ref, unassigned),
                      ),
                    ],
                  ),
                ),
              ),

              // Products list
              if (inCategory.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 24),
                    child: Center(
                      child: Text(
                        l10n.emptyList,
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final p = inCategory[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: p)),
                          ),
                          leading: PlaceholderAvatar(
                            imagePath: p.avatarPath,
                            initials: p.name,
                            backgroundColor: AppColors.pink,
                          ),
                          title: Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle:
                              Text('${p.price.toStringAsFixed(0)}₫'),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.remove_circle_outline),
                            color: AppColors.error,
                            tooltip: l10n.delete,
                            onPressed: () async {
                              final confirmed =
                                  await showDeleteConfirmDialog(
                                context,
                                title: 'Remove from category?',
                                message:
                                    'Product will move to uncategorised.',
                              );
                              if (confirmed == true) {
                                await ref
                                    .read(productsNotifierProvider
                                        .notifier)
                                    .update(p.copyWith(
                                        categoryId:
                                            const Value(null)));
                              }
                            },
                          ),
                        ),
                      );
                    },
                    childCount: inCategory.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  void _showAddProductSheet(
      BuildContext context, WidgetRef ref, List<Product> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Add Products',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return ListTile(
                    leading: PlaceholderAvatar(
                      imagePath: p.avatarPath,
                      initials: p.name,
                      backgroundColor: AppColors.pink,
                    ),
                    title: Text(p.name),
                    subtitle: Text('${p.price.toStringAsFixed(0)}₫'),
                    onTap: () async {
                      await ref
                          .read(productsNotifierProvider.notifier)
                          .update(p.copyWith(
                              categoryId: Value(category.id)));
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
