import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../providers/suppliers_provider.dart';

class SupplierFormScreen extends ConsumerStatefulWidget {
  final Supplier? supplier;
  const SupplierFormScreen({super.key, this.supplier});

  @override
  ConsumerState<SupplierFormScreen> createState() =>
      _SupplierFormScreenState();
}

class _SupplierFormScreenState extends ConsumerState<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _mapCtrl;
  late final TextEditingController _priceNoteCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final s = widget.supplier;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _addressCtrl = TextEditingController(text: s?.address ?? '');
    _mapCtrl = TextEditingController(text: s?.googleMapUrl ?? '');
    _priceNoteCtrl = TextEditingController(text: s?.priceNote ?? '');
    _notesCtrl = TextEditingController(text: s?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _mapCtrl.dispose();
    _priceNoteCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(suppliersNotifierProvider.notifier);
    if (widget.supplier == null) {
      await notifier.add(
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        googleMapUrl: _nullIfEmpty(_mapCtrl.text),
        priceNote: _nullIfEmpty(_priceNoteCtrl.text),
        notes: _nullIfEmpty(_notesCtrl.text),
      );
    } else {
      await notifier.update(widget.supplier!.copyWith(
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        googleMapUrl: Value(_nullIfEmpty(_mapCtrl.text)),
        priceNote: Value(_nullIfEmpty(_priceNoteCtrl.text)),
        notes: Value(_nullIfEmpty(_notesCtrl.text)),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.supplier != null;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEdit ? l10n.supplierFormEdit : l10n.supplierFormAdd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.name),
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.validationRequired(l10n.name)
                    : null,
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
                controller: _mapCtrl,
                decoration: InputDecoration(
                  labelText: l10n.googleMap,
                  prefixIcon: const Icon(Icons.map_outlined),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceNoteCtrl,
                decoration:
                    InputDecoration(labelText: l10n.priceNote),
                minLines: 2,
                maxLines: 4,
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
