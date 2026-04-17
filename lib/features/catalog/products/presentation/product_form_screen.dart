import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/shared/widgets/image_picker_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../categories/providers/categories_provider.dart';
import '../providers/products_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _ingredientCtrl;
  String? _avatarPath;
  List<String> _images = [];
  List<String> _ingredients = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _ingredientCtrl = TextEditingController();
    _avatarPath = p?.avatarPath;
    _selectedCategoryId = p?.categoryId;
    if (p != null) {
      try {
        _images = List<String>.from(jsonDecode(p.images) as List);
        _ingredients = List<String>.from(jsonDecode(p.ingredients) as List);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _ingredientCtrl.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final val = _ingredientCtrl.text.trim();
    if (val.isEmpty) return;
    setState(() {
      _ingredients.add(val);
      _ingredientCtrl.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final notifier = ref.read(productsNotifierProvider.notifier);
    if (widget.product == null) {
      await notifier.add(
        name: _nameCtrl.text.trim(),
        price: price,
        categoryId: _selectedCategoryId,
        avatarPath: _avatarPath,
        images: _images,
        ingredients: _ingredients,
        description:
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      );
    } else {
      await notifier.update(widget.product!.copyWith(
        name: _nameCtrl.text.trim(),
        price: price,
        categoryId: Value(_selectedCategoryId),
        avatarPath: Value(_avatarPath),
        images: jsonEncode(_images),
        ingredients: jsonEncode(_ingredients),
        description: Value(
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.productFormEdit : l10n.productFormAdd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ImagePickerWidget(
                  imagePath: _avatarPath,
                  size: 110,
                  label: l10n.avatar,
                  onPicked: (p) => setState(() => _avatarPath = p),
                ),
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
              categoriesAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (cats) => DropdownButtonFormField<int?>(
                  initialValue: _selectedCategoryId,
                  decoration:
                      InputDecoration(labelText: l10n.category),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.none)),
                    ...cats.map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.name))),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedCategoryId = v),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration:
                    InputDecoration(labelText: l10n.description),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Text(l10n.ingredients,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientCtrl,
                      decoration: const InputDecoration(hintText: 'e.g. Milk'),
                      onSubmitted: (_) => _addIngredient(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _ingredients
                    .map((ing) => Chip(
                          label: Text(ing),
                          onDeleted: () =>
                              setState(() => _ingredients.remove(ing)),
                        ))
                    .toList(),
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
