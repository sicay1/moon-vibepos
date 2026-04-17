import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/delete_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/suppliers_provider.dart';
import 'supplier_form_screen.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final suppliersAsync = ref.watch(suppliersStreamProvider);

    return Scaffold(
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return EmptyStateWidget(
                message: l10n.emptyList, icon: Icons.store_outlined);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: suppliers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final s = suppliers[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.lightGreen,
                    child: Text(
                      s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                          color: AppColors.success, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(s.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (s.address.isNotEmpty) Text(s.address),
                      if (s.priceNote != null && s.priceNote!.isNotEmpty)
                        Text(s.priceNote!,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12)),
                    ],
                  ),
                  isThreeLine: s.address.isNotEmpty && s.priceNote != null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (s.googleMapUrl != null && s.googleMapUrl!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.map_outlined),
                          color: AppColors.secondary,
                          onPressed: () async {
                            final uri = Uri.parse(s.googleMapUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.secondary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  SupplierFormScreen(supplier: s)),
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
                                .read(suppliersNotifierProvider.notifier)
                                .delete(s.id);
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
        heroTag: 'suppliersFab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupplierFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
