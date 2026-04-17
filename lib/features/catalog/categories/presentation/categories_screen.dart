import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/categories_provider.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/placeholder_avatar.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import 'category_form_screen.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyStateWidget(
              message: l10n.emptyList,
              icon: Icons.category_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final cat = categories[i];
              return Card(
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryDetailScreen(category: cat),
                    ),
                  ),
                  leading: PlaceholderAvatar(
                    imagePath: cat.imagePath,
                    initials: cat.name,
                    backgroundColor: AppColors.lightBlue,
                  ),
                  title: Text(cat.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: cat.description != null
                      ? Text(cat.description!,
                          maxLines: 1, overflow: TextOverflow.ellipsis)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.secondary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryFormScreen(category: cat),
                          ),
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
                                .read(categoriesNotifierProvider.notifier)
                                .delete(cat.id);
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
        heroTag: 'categoriesFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
