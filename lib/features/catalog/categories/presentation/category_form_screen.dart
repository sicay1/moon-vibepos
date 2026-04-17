import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/image_picker_widget.dart';
import '../providers/categories_provider.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final Category? category;
  const CategoryFormScreen({super.key, this.category});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');
    _descCtrl =
        TextEditingController(text: widget.category?.description ?? '');
    _imagePath = widget.category?.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(categoriesNotifierProvider.notifier);
    if (widget.category == null) {
      await notifier.add(
        _nameCtrl.text.trim(),
        imagePath: _imagePath,
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
      );
    } else {
      await notifier.update(widget.category!.copyWith(
        name: _nameCtrl.text.trim(),
        imagePath: Value(_imagePath),
        description: Value(
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.category != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.categoryFormEdit : l10n.categoryFormAdd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePickerWidget(
                imagePath: _imagePath,
                size: 110,
                label: l10n.avatar,
                onPicked: (p) => setState(() => _imagePath = p),
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
                controller: _descCtrl,
                decoration: InputDecoration(labelText: l10n.description),
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
