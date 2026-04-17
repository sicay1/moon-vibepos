import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/image_picker_widget.dart';
import '../providers/customers_provider.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  final Customer? customer;
  const CustomerFormScreen({super.key, this.customer});

  @override
  ConsumerState<CustomerFormScreen> createState() =>
      _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _fbCtrl;
  late final TextEditingController _zaloCtrl;
  late final TextEditingController _notesCtrl;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _phoneCtrl = TextEditingController(text: c?.phone ?? '');
    _addressCtrl = TextEditingController(text: c?.address ?? '');
    _fbCtrl = TextEditingController(text: c?.facebookContact ?? '');
    _zaloCtrl = TextEditingController(text: c?.zaloContact ?? '');
    _notesCtrl = TextEditingController(text: c?.notes ?? '');
    _avatarPath = c?.avatarPath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _fbCtrl.dispose();
    _zaloCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(customersNotifierProvider.notifier);
    if (widget.customer == null) {
      await notifier.add(
        name: _nameCtrl.text.trim(),
        phone: _nullIfEmpty(_phoneCtrl.text),
        address: _nullIfEmpty(_addressCtrl.text),
        avatarPath: _avatarPath,
        facebookContact: _nullIfEmpty(_fbCtrl.text),
        zaloContact: _nullIfEmpty(_zaloCtrl.text),
        notes: _nullIfEmpty(_notesCtrl.text),
      );
    } else {
      await notifier.update(widget.customer!.copyWith(
        name: _nameCtrl.text.trim(),
        phone: Value(_nullIfEmpty(_phoneCtrl.text)),
        address: Value(_nullIfEmpty(_addressCtrl.text)),
        avatarPath: Value(_avatarPath),
        facebookContact: Value(_nullIfEmpty(_fbCtrl.text)),
        zaloContact: Value(_nullIfEmpty(_zaloCtrl.text)),
        notes: Value(_nullIfEmpty(_notesCtrl.text)),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.customer != null;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEdit ? l10n.customerFormEdit : l10n.customerFormAdd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePickerWidget(
                imagePath: _avatarPath,
                size: 110,
                label: l10n.avatar,
                onPicked: (p) => setState(() => _avatarPath = p),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.name),
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.validationRequired(l10n.name)
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: InputDecoration(labelText: l10n.phone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: InputDecoration(labelText: l10n.address),
                minLines: 2,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fbCtrl,
                decoration: InputDecoration(
                  labelText: l10n.facebook,
                  prefixIcon: const Icon(Icons.facebook),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zaloCtrl,
                decoration: InputDecoration(
                  labelText: l10n.zalo,
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                decoration: InputDecoration(labelText: l10n.notes),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
