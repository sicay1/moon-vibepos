import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';
import '../providers/cart_provider.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/shared/widgets/placeholder_avatar.dart';
import '../../catalog/products/providers/products_provider.dart';
import '../../catalog/sub_products/providers/sub_products_provider.dart';
import '../../contacts/customers/providers/customers_provider.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  int? _selectedCustomerId;
  double _discount = 0;
  final _noteCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '0');

  @override
  void dispose() {
    _noteCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  Future<void> _finalizeOrder() async {
    final cart = ref.read(cartNotifierProvider);
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }
    final notifier = ref.read(cartNotifierProvider.notifier);
    final total = notifier.total - _discount;
    final lines = notifier.toOrderLines();

    await ref.read(ordersNotifierProvider.notifier).createOrder(
          customerId: _selectedCustomerId,
          totalAmount: total < 0 ? 0 : total,
          discount: _discount,
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
          lines: lines,
        );
    ref.read(cartNotifierProvider.notifier).clear();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newOrder)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _CustomerSelector(
                  selectedId: _selectedCustomerId,
                  onChanged: (id) => setState(() => _selectedCustomerId = id),
                ),
                const SizedBox(height: 12),
                // Cart lines
                ...cart.map(
                  (line) => _CartLineCard(
                    key: ValueKey(line.product.id),
                    line: line,
                    currencyFmt: currencyFmt,
                    onRemove: () =>
                        cartNotifier.removeProduct(line.product.id),
                    onQtyChanged: (q) =>
                        cartNotifier.setQuantity(line.product.id, q),
                    onAddTopping: () => _showToppingPicker(context, line),
                    onRemoveTopping: (tId) =>
                        cartNotifier.removeTopping(line.product.id, tId),
                    onNoteChanged: (note) =>
                        cartNotifier.setNote(line.product.id, note),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _showProductPicker(context),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addToCart),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _discountCtrl,
                  decoration:
                      InputDecoration(labelText: l10n.orderDiscount, suffixText: '₫'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      setState(() => _discount = double.tryParse(v) ?? 0),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(labelText: l10n.orderNote),
                  minLines: 2,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          _BillingBar(
            subtotal: cartNotifier.total,
            discount: _discount,
            currencyFmt: currencyFmt,
            onFinalize: _finalizeOrder,
            l10n: l10n,
          ),
        ],
      ),
    );
  }

  Future<void> _showProductPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ProductPickerSheet(
        onPick: (p) async {
          Navigator.pop(context);
          await _showOptionSelector(context, p);
        },
      ),
    );
  }

  Future<void> _showOptionSelector(BuildContext context, Product product) async {
    final db = ref.read(appDatabaseProvider);
    final sizes =
        await db.optionsDao.watchSizesForProduct(product.id).first;
    final iceLevels =
        await db.optionsDao.watchIceLevelsForProduct(product.id).first;
    final sweetLevels =
        await db.optionsDao.watchSweetLevelsForProduct(product.id).first;

    if (sizes.isEmpty && iceLevels.isEmpty && sweetLevels.isEmpty) {
      ref.read(cartNotifierProvider.notifier).addProduct(product);
      return;
    }

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _OptionSelectorSheet(
        product: product,
        sizes: sizes,
        iceLevels: iceLevels,
        sweetLevels: sweetLevels,
        onConfirm: (size, iceLabel, sweetLabel) {
          ref.read(cartNotifierProvider.notifier).addProductWithOptions(
                product,
                size: size,
                iceLabel: iceLabel,
                sweetLabel: sweetLabel,
              );
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showToppingPicker(BuildContext context, CartLine line) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ToppingPickerSheet(
        productId: line.product.id,
        onPick: (t) {
          ref
              .read(cartNotifierProvider.notifier)
              .addTopping(line.product.id, t);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CustomerSelector extends ConsumerWidget {
  final int? selectedId;
  final void Function(int?) onChanged;
  const _CustomerSelector({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customersAsync = ref.watch(customersStreamProvider);
    return customersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (customers) => DropdownButtonFormField<int?>(
        initialValue: selectedId,
        decoration: InputDecoration(labelText: l10n.orderCustomerOptional),
        items: [
          DropdownMenuItem(value: null, child: Text(l10n.orderNoCustomer)),
          ...customers.map(
              (c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _CartLineCard extends StatefulWidget {
  final CartLine line;
  final NumberFormat currencyFmt;
  final VoidCallback onRemove;
  final void Function(int) onQtyChanged;
  final VoidCallback onAddTopping;
  final void Function(int) onRemoveTopping;
  final void Function(String?) onNoteChanged;

  const _CartLineCard({
    super.key,
    required this.line,
    required this.currencyFmt,
    required this.onRemove,
    required this.onQtyChanged,
    required this.onAddTopping,
    required this.onRemoveTopping,
    required this.onNoteChanged,
  });

  @override
  State<_CartLineCard> createState() => _CartLineCardState();
}

class _CartLineCardState extends State<_CartLineCard> {
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController(text: widget.line.note ?? '');
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PlaceholderAvatar(
                  imagePath: line.product.avatarPath,
                  initials: line.product.name,
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(line.product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(widget.currencyFmt.format(line.product.price),
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                _QtySelector(
                  qty: line.quantity,
                  onChanged: widget.onQtyChanged,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.error,
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            if (line.toppings.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: line.toppings.map((t) {
                  return Chip(
                    label: Text(
                        '${t.subProduct.name} x${t.quantity} (+${widget.currencyFmt.format(t.subProduct.price * t.quantity)})'),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => widget.onRemoveTopping(t.subProduct.id),
                  );
                }).toList(),
              ),
            ],
            if (line.selectedSize != null ||
                line.selectedIceLabel != null ||
                line.selectedSweetLabel != null) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: [
                  if (line.selectedSize != null)
                    Chip(
                      avatar: const Icon(Icons.local_drink_outlined, size: 14),
                      label: Text(line.selectedSize!.price > 0
                          ? '${line.selectedSize!.label} (${widget.currencyFmt.format(line.selectedSize!.price)})'
                          : line.selectedSize!.label),
                      backgroundColor: AppColors.pink.withAlpha(50),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  if (line.selectedIceLabel != null)
                    Chip(
                      avatar: const Icon(Icons.ac_unit, size: 14),
                      label: Text(line.selectedIceLabel!),
                      backgroundColor: Colors.lightBlue.withAlpha(40),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  if (line.selectedSweetLabel != null)
                    Chip(
                      avatar: const Icon(Icons.cake_outlined, size: 14),
                      label: Text(line.selectedSweetLabel!),
                      backgroundColor: Colors.amber.withAlpha(40),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
            TextButton.icon(
              onPressed: widget.onAddTopping,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add topping'),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.secondary),
            ),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note',
                isDense: true,
                prefixIcon: Icon(Icons.note_outlined, size: 18),
              ),
              onChanged: (v) =>
                  widget.onNoteChanged(v.trim().isEmpty ? null : v.trim()),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.currencyFmt.format(line.lineTotal),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtySelector extends StatelessWidget {
  final int qty;
  final void Function(int) onChanged;
  const _QtySelector({required this.qty, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 20),
          onPressed: () => onChanged(qty - 1),
        ),
        Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20),
          onPressed: () => onChanged(qty + 1),
        ),
      ],
    );
  }
}

class _BillingBar extends StatelessWidget {
  final double subtotal;
  final double discount;
  final NumberFormat currencyFmt;
  final VoidCallback onFinalize;
  final AppLocalizations l10n;

  const _BillingBar({
    required this.subtotal,
    required this.discount,
    required this.currencyFmt,
    required this.onFinalize,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final total = (subtotal - discount).clamp(0, double.infinity);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subtotal),
              Text(currencyFmt.format(subtotal)),
            ],
          ),
          if (discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.orderDiscount,
                    style: const TextStyle(color: AppColors.error)),
                Text('-${currencyFmt.format(discount)}',
                    style: const TextStyle(color: AppColors.error)),
              ],
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.orderTotal,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              Text(currencyFmt.format(total),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onFinalize,
            child: Text(l10n.orderFinalize),
          ),
        ],
      ),
    );
  }
}

class _ProductPickerSheet extends ConsumerWidget {
  final void Function(Product) onPick;
  const _ProductPickerSheet({required this.onPick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) => ListView.separated(
          controller: ctrl,
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = products[i];
            return ListTile(
              leading: PlaceholderAvatar(
                imagePath: p.avatarPath,
                initials: p.name,
                backgroundColor: AppColors.pink,
              ),
              title: Text(p.name),
              trailing: Text('${p.price.toStringAsFixed(0)}₫'),
              onTap: () => onPick(p),
            );
          },
        ),
      ),
    );
  }
}

class _ToppingPickerSheet extends ConsumerWidget {
  final int productId;
  final void Function(SubProduct) onPick;
  const _ToppingPickerSheet(
      {required this.productId, required this.onPick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subProductsStreamProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      expand: false,
      builder: (_, ctrl) => subsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (subs) {
          final filtered =
              subs.where((s) => s.productId == productId).toList();
          if (filtered.isEmpty) {
            return const Center(child: Text('No toppings for this product'));
          }
          return ListView.separated(
            controller: ctrl,
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final t = filtered[i];
              return ListTile(
                title: Text(t.name),
                trailing: Text('+${t.price.toStringAsFixed(0)}₫'),
                onTap: () => onPick(t),
              );
            },
          );
        },
      ),
    );
  }
}

class _OptionSelectorSheet extends StatefulWidget {
  final Product product;
  final List<Size> sizes;
  final List<IceLevel> iceLevels;
  final List<SweetLevel> sweetLevels;
  final void Function(Size? size, String? iceLabel, String? sweetLabel)
      onConfirm;

  const _OptionSelectorSheet({
    required this.product,
    required this.sizes,
    required this.iceLevels,
    required this.sweetLevels,
    required this.onConfirm,
  });

  @override
  State<_OptionSelectorSheet> createState() => _OptionSelectorSheetState();
}

class _OptionSelectorSheetState extends State<_OptionSelectorSheet> {
  Size? _selectedSize;
  String? _selectedIceLabel;
  String? _selectedSweetLabel;

  @override
  void initState() {
    super.initState();
    // Pre-select first size if available
    if (widget.sizes.isNotEmpty) _selectedSize = widget.sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(widget.product.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (widget.sizes.isNotEmpty) ...[
                    const Text('Size',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ...widget.sizes.map((s) => RadioListTile<Size>(
                          dense: true,
                          title: Text(
                              s.price > 0 ? '${s.label} — ${fmt.format(s.price)}' : s.label),
                          value: s,
                          groupValue: _selectedSize,
                          onChanged: (v) => setState(() => _selectedSize = v),
                        )),
                    const Divider(),
                  ],
                  if (widget.iceLevels.isNotEmpty) ...[
                    const Text('Ice',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioListTile<String?>(
                      dense: true,
                      title: const Text('Default'),
                      value: null,
                      groupValue: _selectedIceLabel,
                      onChanged: (v) => setState(() => _selectedIceLabel = v),
                    ),
                    ...widget.iceLevels.map((il) => RadioListTile<String?>(
                          dense: true,
                          title: Text(il.label),
                          value: il.label,
                          groupValue: _selectedIceLabel,
                          onChanged: (v) =>
                              setState(() => _selectedIceLabel = v),
                        )),
                    const Divider(),
                  ],
                  if (widget.sweetLevels.isNotEmpty) ...[
                    const Text('Sweet',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioListTile<String?>(
                      dense: true,
                      title: const Text('Default'),
                      value: null,
                      groupValue: _selectedSweetLabel,
                      onChanged: (v) =>
                          setState(() => _selectedSweetLabel = v),
                    ),
                    ...widget.sweetLevels.map((sl) => RadioListTile<String?>(
                          dense: true,
                          title: Text(sl.label),
                          value: sl.label,
                          groupValue: _selectedSweetLabel,
                          onChanged: (v) =>
                              setState(() => _selectedSweetLabel = v),
                        )),
                    const Divider(),
                  ],
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => widget.onConfirm(
                        _selectedSize, _selectedIceLabel, _selectedSweetLabel),
                    child: Text(AppLocalizations.of(context).addToCart),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
