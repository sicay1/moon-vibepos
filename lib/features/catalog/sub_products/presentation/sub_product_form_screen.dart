import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/image_picker_widget.dart';
import '../../products/providers/products_provider.dart';
import '../providers/sub_products_provider.dart';

class SubProductFormScreen extends ConsumerStatefulWidget {
  final SubProduct? subProduct;
  final int? preSelectedProductId;
  const SubProductFormScreen(
      {super.key, this.subProduct, this.preSelectedProductId});

  @override
  ConsumerState<SubProductFormScreen> createState() =>
      _SubProductFormScreenState();
}

class _SubProductFormScreenState extends ConsumerState<SubProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  String? _avatarPath;
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    final s = widget.subProduct;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _priceCtrl = TextEditingController(
        text: s != null ? s.price.toStringAsFixed(0) : '');
    _avatarPath = s?.avatarPath;
    _selectedProductId = s?.productId ?? widget.preSelectedProductId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final notifier = ref.read(subProductsNotifierProvider.notifier);
    if (widget.subProduct == null) {
      await notifier.add(
        productId: _selectedProductId!,
        name: _nameCtrl.text.trim(),
        price: price,
        avatarPath: _avatarPath,
      );
    } else {
      await notifier.update(widget.subProduct!.copyWith(
        name: _nameCtrl.text.trim(),
        price: price,
        productId: _selectedProductId!,
        avatarPath: Value(_avatarPath),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final productsAsync = ref.watch(productsStreamProvider);
    final isEdit = widget.subProduct != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.toppingFormEdit : l10n.toppingFormAdd),
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
                controller: _priceCtrl,
                decoration: InputDecoration(
                    labelText: l10n.price, suffixText: '₫'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.validationRequired(l10n.price);
                  }
                  if (double.tryParse(v) == null || double.parse(v) < 0) {
                    return l10n.validationPositiveNumber(l10n.price);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              productsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (products) => DropdownButtonFormField<int>(
                  initialValue: _selectedProductId,
                  decoration:
                      InputDecoration(labelText: l10n.parentProduct),
                  items: products
                      .map((p) => DropdownMenuItem(
                          value: p.id, child: Text(p.name)))
                      .toList(),
                  onChanged: widget.preSelectedProductId != null
                      ? null
                      : (v) => setState(() => _selectedProductId = v),
                  validator: (v) => v == null
                      ? l10n.validationRequired(l10n.parentProduct)
                      : null,
                ),
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
