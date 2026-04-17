import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../sub_products/providers/sub_products_provider.dart';
import '../../sub_products/presentation/sub_product_form_screen.dart';
import '../providers/options_provider.dart';
// import '../providers/products_provider.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subProductsAsync = ref.watch(subProductsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductFormScreen(product: product)),
            ),
          ),
        ],
      ),
      body: subProductsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (allSubs) {
          final toppings = allSubs
              .where((s) => s.productId == product.id)
              .toList();

          return CustomScrollView(
            slivers: [
              // Product info card
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlaceholderAvatar(
                          imagePath: product.avatarPath,
                          initials: product.name,
                          radius: 36,
                          backgroundColor: AppColors.pink,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(0)}₫',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              if (product.description != null &&
                                  product.description!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  product.description!,
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

              // Toppings section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  child: Text(
                    l10n.tabToppings,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Toppings list
              if (toppings.isEmpty)
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
                      final sub = toppings[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: PlaceholderAvatar(
                            imagePath: sub.avatarPath,
                            initials: sub.name,
                            backgroundColor: AppColors.lightGreen,
                          ),
                          title: Text(sub.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle:
                              Text('${sub.price.toStringAsFixed(0)}₫'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                color: AppColors.secondary,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubProductFormScreen(
                                        subProduct: sub),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.error,
                                onPressed: () async {
                                  final confirmed =
                                      await showDeleteConfirmDialog(
                                    context,
                                    title: l10n.deleteConfirmTitle,
                                    message: l10n.deleteConfirmMessage,
                                  );
                                  if (confirmed == true) {
                                    await ref
                                        .read(subProductsNotifierProvider
                                            .notifier)
                                        .delete(sub.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: toppings.length,
                  ),
                ),

              // ── Options sections ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: _OptionSection<Size>(
                  title: 'Size',
                  allOptionsAsync: ref.watch(sizesStreamProvider),
                  enabledOptionsAsync:
                      ref.watch(productSizesStreamProvider(product.id)),
                  getId: (s) => s.id,
                  getLabel: (s) =>
                      s.price > 0 ? '${s.label}  ${s.price.toStringAsFixed(0)}₫' : '${s.label}  — set price',
                  onToggle: (sizeId, enabled) => ref
                      .read(productOptionsNotifierProvider.notifier)
                      .toggleSize(product.id, sizeId, enabled),
                  onAddOption: () => _showAddSizeDialog(context, ref),
                  onEditItem: (s) => _showEditSizePriceDialog(context, ref, s),
                ),
              ),
              SliverToBoxAdapter(
                child: _OptionSection<IceLevel>(
                  title: 'Ice',
                  allOptionsAsync: ref.watch(iceLevelsStreamProvider),
                  enabledOptionsAsync:
                      ref.watch(productIceLevelsStreamProvider(product.id)),
                  getId: (s) => s.id,
                  getLabel: (s) => s.label,
                  onToggle: (iceLevelId, enabled) => ref
                      .read(productOptionsNotifierProvider.notifier)
                      .toggleIceLevel(product.id, iceLevelId, enabled),
                  onAddOption: () => _showAddLabelDialog(
                    context,
                    title: 'Add Ice Level',
                    onConfirm: (label) => ref
                        .read(iceLevelsNotifierProvider.notifier)
                        .add(label),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _OptionSection<SweetLevel>(
                  title: 'Sweet',
                  allOptionsAsync: ref.watch(sweetLevelsStreamProvider),
                  enabledOptionsAsync:
                      ref.watch(productSweetLevelsStreamProvider(product.id)),
                  getId: (s) => s.id,
                  getLabel: (s) => s.label,
                  onToggle: (sweetLevelId, enabled) => ref
                      .read(productOptionsNotifierProvider.notifier)
                      .toggleSweetLevel(product.id, sweetLevelId, enabled),
                  onAddOption: () => _showAddLabelDialog(
                    context,
                    title: 'Add Sweet Level',
                    onConfirm: (label) => ref
                        .read(sweetLevelsNotifierProvider.notifier)
                        .add(label),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 88)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'productDetailFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubProductFormScreen(
                preSelectedProductId: product.id),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showEditSizePriceDialog(
      BuildContext context, WidgetRef ref, Size size) async {
    final priceCtrl = TextEditingController(
        text: size.price > 0 ? size.price.toStringAsFixed(0) : '');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Price for ${size.label}'),
        content: TextField(
          controller: priceCtrl,
          decoration: const InputDecoration(
            labelText: 'Price (₫)',
            suffixText: '₫',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final price = double.tryParse(priceCtrl.text) ?? 0;
              await ref
                  .read(sizesNotifierProvider.notifier)
                  .updatePrice(size.id, price);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSizeDialog(BuildContext context, WidgetRef ref) async {
    final labelCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '0');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(labelText: 'Label (e.g. Large 1L)'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price (₫)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              final price = double.tryParse(priceCtrl.text) ?? 0;
              await ref.read(sizesNotifierProvider.notifier).add(label, price);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddLabelDialog(
    BuildContext context, {
    required String title,
    required Future<void> Function(String label) onConfirm,
  }) async {
    final ctrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Label'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final label = ctrl.text.trim();
              if (label.isEmpty) return;
              await onConfirm(label);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable option section widget ────────────────────────────────────────────

class _OptionSection<T> extends StatelessWidget {
  final String title;
  final AsyncValue<List<T>> allOptionsAsync;
  final AsyncValue<List<T>> enabledOptionsAsync;
  final int Function(T) getId;
  final String Function(T) getLabel;
  final Future<void> Function(int id, bool enabled) onToggle;
  final VoidCallback onAddOption;
  final Future<void> Function(T item)? onEditItem;

  const _OptionSection({
    required this.title,
    required this.allOptionsAsync,
    required this.enabledOptionsAsync,
    required this.getId,
    required this.getLabel,
    required this.onToggle,
    required this.onAddOption,
    this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onAddOption,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
        allOptionsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Error: $e'),
          ),
          data: (allOptions) {
            if (allOptions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'No ${title.toLowerCase()} options yet. Tap Add to create one.',
                  style: const TextStyle(color: AppColors.onSurfaceVariant),
                ),
              );
            }
            final enabledIds = enabledOptionsAsync.valueOrNull
                    ?.map((e) => getId(e))
                    .toSet() ??
                {};
            return Column(
              children: allOptions.map((opt) {
                final isEnabled = enabledIds.contains(getId(opt));
                return CheckboxListTile(
                  dense: true,
                  title: Text(getLabel(opt)),
                  secondary: onEditItem != null
                      ? IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          color: AppColors.onSurfaceVariant,
                          onPressed: () => onEditItem!(opt),
                        )
                      : null,
                  value: isEnabled,
                  onChanged: (v) => onToggle(getId(opt), v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
