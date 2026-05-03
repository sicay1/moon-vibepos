import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/cleanup_provider.dart';
import '../providers/backup_provider.dart';
import '../providers/sync_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'options_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeNotifierProvider);

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Language ────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsLanguage,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LangButton(
                          label: l10n.settingsLangEn,
                          isSelected: locale.languageCode == 'en',
                          onTap: () => ref
                              .read(localeNotifierProvider.notifier)
                              .setLocale(const Locale('en')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LangButton(
                          label: l10n.settingsLangVi,
                          isSelected: locale.languageCode == 'vi',
                          onTap: () => ref
                              .read(localeNotifierProvider.notifier)
                              .setLocale(const Locale('vi')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Product Options ──────────────────────────────────────────────
          Card(
            child: ListTile(
              leading: const Icon(Icons.tune_outlined, color: AppColors.secondary),
              title: const Text('Product Options',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Manage sizes, ice levels & sweet levels'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OptionsScreen()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Backup & Restore ─────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(l10n.settingsBackup,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined,
                        color: Colors.teal),
                    title: Text(l10n.backupCreate),
                    subtitle: Text(l10n.backupCreateSubtitle),
                    onTap: () => _runBackup(context, ref, l10n),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore_outlined,
                        color: Colors.indigo),
                    title: Text(l10n.backupRestore),
                    subtitle: Text(l10n.backupRestoreSubtitle),
                    onTap: () => _runRestore(context, ref, l10n),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Database cleanup ─────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(l10n.settingsDatabase,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                  _CleanupTile(
                    icon: Icons.receipt_long_outlined,
                    color: Colors.orange,
                    title: l10n.cleanupClearOrders,
                    subtitle: l10n.cleanupClearOrdersSubtitle,
                    onTap: () => _showOrdersClearDialog(context, ref, l10n),
                  ),
                  _CleanupTile(
                    icon: Icons.people_outline,
                    color: Colors.blue,
                    title: l10n.cleanupClearCustomers,
                    subtitle: l10n.cleanupClearCustomersSubtitle,
                    onTap: () => _showConfirmDialog(
                      context: context,
                      ref: ref,
                      title: l10n.cleanupClearCustomers,
                      description: l10n.cleanupClearCustomersDesc,
                      successMessage: l10n.cleanupSuccessMessage(l10n.cleanupClearCustomers),
                      onConfirmed: () => ref
                          .read(cleanupNotifierProvider.notifier)
                          .clearCustomers(),
                    ),
                  ),
                  _CleanupTile(
                    icon: Icons.local_shipping_outlined,
                    color: Colors.teal,
                    title: l10n.cleanupClearSuppliers,
                    subtitle: l10n.cleanupClearSuppliersSubtitle,
                    onTap: () => _showConfirmDialog(
                      context: context,
                      ref: ref,
                      title: l10n.cleanupClearSuppliers,
                      description: l10n.cleanupClearSuppliersDesc,
                      successMessage: l10n.cleanupSuccessMessage(l10n.cleanupClearSuppliers),
                      onConfirmed: () => ref
                          .read(cleanupNotifierProvider.notifier)
                          .clearSuppliers(),
                    ),
                  ),
                  _CleanupTile(
                    icon: Icons.storefront_outlined,
                    color: Colors.purple,
                    title: l10n.cleanupClearCatalog,
                    subtitle: l10n.cleanupClearCatalogSubtitle,
                    onTap: () => _showConfirmDialog(
                      context: context,
                      ref: ref,
                      title: l10n.cleanupClearCatalog,
                      description: l10n.cleanupClearCatalogDesc,
                      successMessage: l10n.cleanupSuccessMessage(l10n.cleanupClearCatalog),
                      onConfirmed: () => ref
                          .read(cleanupNotifierProvider.notifier)
                          .clearCatalog(),
                    ),
                  ),
                  _CleanupTile(
                    icon: Icons.tune_outlined,
                    color: Colors.indigo,
                    title: l10n.cleanupResetOptions,
                    subtitle: l10n.cleanupResetOptionsSubtitle,
                    onTap: () => _showConfirmDialog(
                      context: context,
                      ref: ref,
                      title: l10n.cleanupResetOptions,
                      description: l10n.cleanupResetOptionsDesc,
                      successMessage: l10n.cleanupSuccessMessage(l10n.cleanupResetOptions),
                      onConfirmed: () => ref
                          .read(cleanupNotifierProvider.notifier)
                          .resetOptions(),
                    ),
                  ),
                  const Divider(height: 1),
                  _CleanupTile(
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                    title: l10n.cleanupFactoryReset,
                    subtitle: l10n.cleanupFactoryResetSubtitle,
                    onTap: () => _showConfirmDialog(
                      context: context,
                      ref: ref,
                      title: l10n.cleanupFactoryReset,
                      description: l10n.cleanupFactoryResetDesc,
                      successMessage: l10n.cleanupSuccessMessage(l10n.cleanupFactoryReset),
                      onConfirmed: () => ref
                          .read(cleanupNotifierProvider.notifier)
                          .factoryReset(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Google Sheets Sync ───────────────────────────────────────────
          const _GoogleSheetsCard(),
          const SizedBox(height: 12),
          // ── About ────────────────────────────────────────────────────────
          _AboutCard(l10n: l10n),
        ],
      );
  }

  Future<void> _runBackup(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    // Step 1 — build the archive
    final loadingDialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(l10n.backupInProgress),
          ]),
        ),
      ),
    );

    String? zipPath;
    try {
      zipPath = await ref.read(backupNotifierProvider.notifier).backup();
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${l10n.backupFailed}: $e'),
          backgroundColor: AppColors.error,
        ));
      }
      loadingDialog.ignore();
      return;
    }

    if (!context.mounted) { loadingDialog.ignore(); return; }
    Navigator.of(context).pop(); // dismiss loading

    // Step 2 — ask what to do with the file
    final fileName = zipPath.split(RegExp(r'[/\\]')).last;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.backupSuccess,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt_outlined, color: Colors.teal),
              title: Text(l10n.backupSaveToDevice),
              onTap: () async {
                Navigator.pop(ctx);
                final bytes = File(zipPath!).readAsBytesSync();
                final result = await FilePicker.platform.saveFile(
                  dialogTitle: l10n.backupSaveToDevice,
                  fileName: fileName,
                  bytes: bytes,
                  type: FileType.any,
                );
                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.backupSuccess)),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined, color: Colors.indigo),
              title: Text(l10n.backupShare),
              onTap: () async {
                Navigator.pop(ctx);
                await Share.shareXFiles([XFile(zipPath!)],
                    subject: 'MoonPOS Backup');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    loadingDialog.ignore();
  }

  Future<void> _runRestore(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    // Warn the user
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupRestore),
        content: Text(l10n.backupRestoreWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Pick file
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, withData: false);
    if (result == null || result.files.single.path == null) return;
    final filePath = result.files.single.path!;

    if (!context.mounted) return;

    // Show progress and restore
    final loadingDialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(l10n.restoreInProgress),
          ]),
        ),
      ),
    );
    try {
      await ref.read(backupNotifierProvider.notifier).restore(filePath);
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restoreSuccess)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.restoreFailed}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
    loadingDialog.ignore();
  }

  Future<void> _showOrdersClearDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    DateTime? cutoff;
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => _OrdersClearSheet(
        l10n: l10n,
        onClearAll: () {
          Navigator.pop(ctx);
          _showConfirmDialog(
            context: context,
            ref: ref,
            title: l10n.cleanupClearOrders,
            description: l10n.cleanupClearOrdersAllDesc,
            successMessage: l10n.cleanupSuccessMessage(l10n.cleanupClearOrders),
            onConfirmed: () =>
                ref.read(cleanupNotifierProvider.notifier).clearAllOrders(),
          );
        },
        onClearOlderThan: (date) {
          cutoff = date;
          Navigator.pop(ctx);
          _showConfirmDialog(
            context: context,
            ref: ref,
            title: l10n.cleanupClearOrders,
            description: l10n.cleanupClearOrdersOlderThanDesc(_formatDate(cutoff!)),
            successMessage: l10n.cleanupSuccessMessage(l10n.cleanupClearOrders),
            onConfirmed: () => ref
                .read(cleanupNotifierProvider.notifier)
                .clearOrdersOlderThan(cutoff!),
          );
        },
      ),
    );
  }

  Future<void> _showConfirmDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String description,
    required String successMessage,
    required Future<void> Function() onConfirmed,
  }) async {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    await showDialog(
      context: context,
      builder: (ctx) => _ConfirmDeleteDialog(
        title: title,
        description: description,
        ctrl: ctrl,
        confirmTypeHint: l10n.cleanupConfirmTypeHint,
        confirmButtonLabel: l10n.cleanupConfirmButton,
        cancelLabel: l10n.cancel,
        onConfirmed: () async {
          Navigator.pop(ctx);
          await onConfirmed();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(successMessage),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _CleanupTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CleanupTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(30),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _OrdersClearSheet extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onClearAll;
  final void Function(DateTime cutoff) onClearOlderThan;

  const _OrdersClearSheet(
      {required this.l10n, required this.onClearAll, required this.onClearOlderThan});

  @override
  State<_OrdersClearSheet> createState() => _OrdersClearSheetState();
}

class _OrdersClearSheetState extends State<_OrdersClearSheet> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.l10n.cleanupClearOrders,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.orange),
              title: Text(widget.l10n.cleanupClearOrdersAll),
              subtitle: Text(widget.l10n.cleanupClearOrdersAllSubtitle),
              onTap: widget.onClearAll,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.date_range_outlined, color: Colors.blue),
              title: Text(widget.l10n.cleanupClearOrdersOlderThan),
              subtitle: Text(_selectedDate == null
                  ? widget.l10n.cleanupClearOrdersOlderThanSubtitle
                  : widget.l10n.cleanupClearOrdersOlderThanSelected(
                      _selectedDate!.day.toString().padLeft(2, '0'),
                      _selectedDate!.month.toString().padLeft(2, '0'),
                      _selectedDate!.year.toString(),
                    )),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 90)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedDate == null
                    ? null
                    : () => widget.onClearOlderThan(_selectedDate!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(widget.l10n.cleanupClearOrdersOlderThanButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmDeleteDialog extends StatefulWidget {
  final String title;
  final String description;
  final TextEditingController ctrl;
  final String confirmTypeHint;
  final String confirmButtonLabel;
  final String cancelLabel;
  final VoidCallback onConfirmed;

  const _ConfirmDeleteDialog({
    required this.title,
    required this.description,
    required this.ctrl,
    required this.confirmTypeHint,
    required this.confirmButtonLabel,
    required this.cancelLabel,
    required this.onConfirmed,
  });

  @override
  State<_ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<_ConfirmDeleteDialog> {
  bool _matches = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded,
          color: AppColors.error, size: 36),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.description,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),
          Text(
            widget.confirmTypeHint,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'DELETE',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _matches = v == 'DELETE'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelLabel),
        ),
        ElevatedButton(
          onPressed: _matches ? widget.onConfirmed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: Text(widget.confirmButtonLabel),
        ),
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _LangButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

// ── Google Sheets Sync Card ──────────────────────────────────────────────────

class _GoogleSheetsCard extends ConsumerStatefulWidget {
  const _GoogleSheetsCard();

  @override
  ConsumerState<_GoogleSheetsCard> createState() => _GoogleSheetsCardState();
}

class _GoogleSheetsCardState extends ConsumerState<_GoogleSheetsCard> {
  final _urlCtrl = TextEditingController();
  bool _urlDirty = false;

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(syncSettingsNotifierProvider);
    final syncState = ref.watch(syncNotifierProvider);

    // Populate the text field once settings load
    settingsAsync.whenData((s) {
      if (!_urlDirty && _urlCtrl.text != s.webAppUrl) {
        _urlCtrl.text = s.webAppUrl;
      }
    });

    final isSyncing = syncState is SyncInProgress;
    final webAppUrl = settingsAsync.valueOrNull?.webAppUrl ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.table_chart_outlined, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Google Sheets Sync',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlCtrl,
              onChanged: (_) => setState(() => _urlDirty = true),
              enabled: false, // TODO Disable editing because current feature is not ready yet. Will enable in a future update.
              decoration: const InputDecoration(
                labelText: 'Apps Script Web App URL',
                // hintText: 'https://script.google.com/macros/s/.../exec',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: null, // TODO Disable saving because current feature is not ready yet.
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  backgroundColor: Colors.grey.shade200,
                ),
                // onPressed: _urlDirty
                //     ? () async {
                //         await ref
                //             .read(syncSettingsNotifierProvider.notifier)
                //             .saveWebAppUrl(_urlCtrl.text);
                //         setState(() => _urlDirty = false);
                //         if (context.mounted) {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(content: Text('URL saved')),
                //           );
                //         }
                //       }
                //     : null,
                child: const Text('Save URL'),
                
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: null, // TODO Disable syncing because current feature is not ready yet.
                // onPressed: (isSyncing || webAppUrl.isEmpty)
                //     ? null
                //     : () => ref.read(syncNotifierProvider.notifier).sync(),
                icon: isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync),
                label: Text(isSyncing ? 'Syncing…' : 'Sync Orders'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _SyncStatusText(syncState),
          ],
        ),
      ),
    );
  }
}

class _SyncStatusText extends StatelessWidget {
  final SyncState state;
  const _SyncStatusText(this.state);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      SyncIdle() => const SizedBox.shrink(),
      SyncInProgress() => const Text(
          'Syncing orders…',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      SyncSuccess(:final count, :final syncedAt) => Text(
          count == 0
              ? 'No new orders to sync.'
              : 'Synced $count order${count == 1 ? '' : 's'} on '
                  '${syncedAt.day.toString().padLeft(2, '0')}-'
                  '${syncedAt.month.toString().padLeft(2, '0')}-'
                  '${syncedAt.year} '
                  '${syncedAt.hour.toString().padLeft(2, '0')}:'
                  '${syncedAt.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12, color: Colors.green),
        ),
      SyncError(:final message) => Text(
          'Error: $message',
          style: const TextStyle(fontSize: 12, color: Colors.red),
        ),
    };
  }
}

// ── About Card ───────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _AboutCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(l10n.aboutTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.teal),
              title: Text(l10n.aboutAuthor),
              subtitle: Text(l10n.aboutAuthorName),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '...';
                final buildNumber = snapshot.data?.buildNumber ?? '';
                final display = buildNumber.isNotEmpty
                    ? '$version+$buildNumber'
                    : version;
                return ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: Text(l10n.aboutVersion),
                  subtitle: Text(display),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.description_outlined, color: Colors.indigo),
              title: Text(l10n.aboutOpenSourceLicenses),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'MoonPOS',
                  applicationIcon: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.point_of_sale, size: 48),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
