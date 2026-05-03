import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../catalog/products/providers/options_provider.dart';

class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Options'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sizes'),
              Tab(text: 'Ice'),
              Tab(text: 'Sweet'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SizesTab(),
            _IceTab(),
            _SweetTab(),
          ],
        ),
      ),
    );
  }
}

// ── Sizes Tab ─────────────────────────────────────────────────────────────────

class _SizesTab extends ConsumerWidget {
  const _SizesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizesAsync = ref.watch(sizesStreamProvider);
    return Scaffold(
      body: sizesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sizes) {
          if (sizes.isEmpty) {
            return const Center(
              child: Text('No sizes. Tap + to add one.',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sizes.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
            itemBuilder: (_, i) {
              final s = sizes[i];
              return ListTile(
                title: Text(s.label),
                subtitle: Text(
                  'Default price: ${s.price.toStringAsFixed(0)}₫  ·  Sort: ${s.sortOrder}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.secondary,
                      onPressed: () =>
                          _showEditSizeDialog(context, ref, s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () =>
                          _confirmDelete(context, ref, s.id, s.label,
                              () => ref.read(sizesNotifierProvider.notifier).delete(s.id)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'sizesFab',
        onPressed: () => _showAddSizeDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddSizeDialog(BuildContext context, WidgetRef ref) async {
    final labelCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '0');
    final sortCtrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(
                  labelText: 'Label', hintText: 'e.g. Large (1L)'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                  labelText: 'Default price (₫)',
                  helperText: 'Used as pre-fill when assigning to a product'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sortCtrl,
              decoration: const InputDecoration(
                  labelText: 'Sort order', hintText: 'e.g. 4'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
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

  Future<void> _showEditSizeDialog(
      BuildContext context, WidgetRef ref, Size size) async {
    final labelCtrl = TextEditingController(text: size.label);
    final priceCtrl =
        TextEditingController(text: size.price.toStringAsFixed(0));
    final sortCtrl =
        TextEditingController(text: size.sortOrder.toString());
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(labelText: 'Label'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                  labelText: 'Default price (₫)',
                  helperText:
                      'Does not change prices already set per-product'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sortCtrl,
              decoration:
                  const InputDecoration(labelText: 'Sort order'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              final price = double.tryParse(priceCtrl.text) ?? 0;
              final sort = int.tryParse(sortCtrl.text) ?? size.sortOrder;
              await ref
                  .read(sizesNotifierProvider.notifier)
                  .update(size.id, label, price, sort);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Ice Tab ───────────────────────────────────────────────────────────────────

class _IceTab extends ConsumerWidget {
  const _IceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iceLevelsAsync = ref.watch(iceLevelsStreamProvider);
    return Scaffold(
      body: iceLevelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (levels) {
          if (levels.isEmpty) {
            return const Center(
              child: Text('No ice levels. Tap + to add one.',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: levels.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
            itemBuilder: (_, i) {
              final lvl = levels[i];
              return ListTile(
                title: Text(lvl.label),
                subtitle: Text('Sort: ${lvl.sortOrder}',
                    style: const TextStyle(fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.secondary,
                      onPressed: () =>
                          _showEditDialog(context, ref, lvl),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () => _confirmDelete(
                          context, ref, lvl.id, lvl.label,
                          () => ref.read(iceLevelsNotifierProvider.notifier).delete(lvl.id)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'iceFab',
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final labelCtrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Ice Level'),
        content: TextField(
          controller: labelCtrl,
          decoration: const InputDecoration(
              labelText: 'Label', hintText: 'e.g. Extra Ice'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              await ref.read(iceLevelsNotifierProvider.notifier).add(label);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, WidgetRef ref, IceLevel level) async {
    final labelCtrl = TextEditingController(text: level.label);
    final sortCtrl =
        TextEditingController(text: level.sortOrder.toString());
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Ice Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(labelText: 'Label'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sortCtrl,
              decoration:
                  const InputDecoration(labelText: 'Sort order'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              final sort = int.tryParse(sortCtrl.text) ?? level.sortOrder;
              await ref
                  .read(iceLevelsNotifierProvider.notifier)
                  .update(level.id, label, sort);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Sweet Tab ─────────────────────────────────────────────────────────────────

class _SweetTab extends ConsumerWidget {
  const _SweetTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sweetLevelsAsync = ref.watch(sweetLevelsStreamProvider);
    return Scaffold(
      body: sweetLevelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (levels) {
          if (levels.isEmpty) {
            return const Center(
              child: Text('No sweet levels. Tap + to add one.',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: levels.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
            itemBuilder: (_, i) {
              final lvl = levels[i];
              return ListTile(
                title: Text(lvl.label),
                subtitle: Text('Sort: ${lvl.sortOrder}',
                    style: const TextStyle(fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.secondary,
                      onPressed: () =>
                          _showEditDialog(context, ref, lvl),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () => _confirmDelete(
                          context, ref, lvl.id, lvl.label,
                          () => ref.read(sweetLevelsNotifierProvider.notifier).delete(lvl.id)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'sweetFab',
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final labelCtrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Sweet Level'),
        content: TextField(
          controller: labelCtrl,
          decoration: const InputDecoration(
              labelText: 'Label', hintText: 'e.g. Extra Sweet'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              await ref.read(sweetLevelsNotifierProvider.notifier).add(label);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, WidgetRef ref, SweetLevel level) async {
    final labelCtrl = TextEditingController(text: level.label);
    final sortCtrl =
        TextEditingController(text: level.sortOrder.toString());
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Sweet Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(labelText: 'Label'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sortCtrl,
              decoration:
                  const InputDecoration(labelText: 'Sort order'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final label = labelCtrl.text.trim();
              if (label.isEmpty) return;
              final sort = int.tryParse(sortCtrl.text) ?? level.sortOrder;
              await ref
                  .read(sweetLevelsNotifierProvider.notifier)
                  .update(level.id, label, sort);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Shared helper ─────────────────────────────────────────────────────────────

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  int id,
  String label,
  Future<void> Function() onConfirmed,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete'),
      content: Text('Delete "$label"? This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await onConfirmed();
  }
}
