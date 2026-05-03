import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/daos/options_dao.dart';

part 'cart_provider.g.dart';

class CartTopping {
  final SubProduct subProduct;
  int quantity;
  CartTopping({required this.subProduct, this.quantity = 1});
}

class CartLine {
  final Product product;
  int quantity;
  List<CartTopping> toppings;
  String? note;
  ProductSizeOption? selectedSize;
  String? selectedIceLabel;
  String? selectedSweetLabel;

  CartLine({
    required this.product,
    this.quantity = 1,
    List<CartTopping>? toppings,
    this.note,
    this.selectedSize,
    this.selectedIceLabel,
    this.selectedSweetLabel,
  }) : toppings = toppings ?? [];

  double get lineTotal {
    final toppingTotal =
        toppings.fold<double>(0, (s, t) => s + t.subProduct.price * t.quantity);
    final basePrice = selectedSize?.price ?? product.price;
    return (basePrice + toppingTotal) * quantity;
  }
}

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartLine> build() => [];

  void addProduct(Product product) {
    final idx = state.indexWhere((l) => l.product.id == product.id);
    if (idx >= 0) {
      final updated = [...state];
      final old = updated[idx];
      updated[idx] = CartLine(
        product: old.product,
        quantity: old.quantity + 1,
        toppings: old.toppings,
        note: old.note,
        selectedSize: old.selectedSize,
        selectedIceLabel: old.selectedIceLabel,
        selectedSweetLabel: old.selectedSweetLabel,
      );
      state = updated;
    } else {
      state = [...state, CartLine(product: product)];
    }
  }

  void addProductWithOptions(
    Product product, {
    ProductSizeOption? size,
    String? iceLabel,
    String? sweetLabel,
  }) {
    state = [
      ...state,
      CartLine(
        product: product,
        selectedSize: size,
        selectedIceLabel: iceLabel,
        selectedSweetLabel: sweetLabel,
      ),
    ];
  }

  void setOptions(
    int productId, {
    ProductSizeOption? size,
    String? iceLabel,
    String? sweetLabel,
  }) {
    state = state.map((l) {
      if (l.product.id != productId) return l;
      return CartLine(
        product: l.product,
        quantity: l.quantity,
        toppings: l.toppings,
        note: l.note,
        selectedSize: size,
        selectedIceLabel: iceLabel,
        selectedSweetLabel: sweetLabel,
      );
    }).toList();
  }

  void removeProduct(int productId) {
    state = state.where((l) => l.product.id != productId).toList();
  }

  void setQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    state = state.map((l) {
      if (l.product.id != productId) return l;
      return CartLine(
        product: l.product,
        quantity: quantity,
        toppings: l.toppings,
        note: l.note,
        selectedSize: l.selectedSize,
        selectedIceLabel: l.selectedIceLabel,
        selectedSweetLabel: l.selectedSweetLabel,
      );
    }).toList();
  }

  void addTopping(int productId, SubProduct topping) {
    state = state.map((l) {
      if (l.product.id != productId) return l;
      final toppingIdx = l.toppings.indexWhere((t) => t.subProduct.id == topping.id);
      final updatedToppings = [...l.toppings];
      if (toppingIdx >= 0) {
        updatedToppings[toppingIdx] = CartTopping(
          subProduct: topping,
          quantity: updatedToppings[toppingIdx].quantity + 1,
        );
      } else {
        updatedToppings.add(CartTopping(subProduct: topping));
      }
      return CartLine(
        product: l.product,
        quantity: l.quantity,
        toppings: updatedToppings,
        note: l.note,
        selectedSize: l.selectedSize,
        selectedIceLabel: l.selectedIceLabel,
        selectedSweetLabel: l.selectedSweetLabel,
      );
    }).toList();
  }

  void removeTopping(int productId, int toppingId) {
    state = state.map((l) {
      if (l.product.id != productId) return l;
      return CartLine(
        product: l.product,
        quantity: l.quantity,
        toppings: l.toppings.where((t) => t.subProduct.id != toppingId).toList(),
        note: l.note,
        selectedSize: l.selectedSize,
        selectedIceLabel: l.selectedIceLabel,
        selectedSweetLabel: l.selectedSweetLabel,
      );
    }).toList();
  }

  void setNote(int productId, String? note) {
    state = state.map((l) {
      if (l.product.id != productId) return l;
      return CartLine(
        product: l.product,
        quantity: l.quantity,
        toppings: l.toppings,
        note: note,
        selectedSize: l.selectedSize,
        selectedIceLabel: l.selectedIceLabel,
        selectedSweetLabel: l.selectedSweetLabel,
      );
    }).toList();
  }

  void clear() => state = [];

  double get total =>
      state.fold<double>(0, (sum, line) => sum + line.lineTotal);

  List<({OrderItemsCompanion item, List<OrderItemToppingsCompanion> toppings})>
      toOrderLines() {
    return state.map((line) {
      final item = OrderItemsCompanion.insert(
        orderId: 0, // will be replaced by DAO
        productId: line.product.id,
        productName: line.product.name,
        unitPrice: line.product.price,
        quantity: Value(line.quantity),
        note: Value(line.note),
        sizeLabel: Value(line.selectedSize?.label),
        sizePrice: Value(line.selectedSize?.price),
        iceLabel: Value(line.selectedIceLabel),
        sweetLabel: Value(line.selectedSweetLabel),
      );
      final toppingCompanions = line.toppings
          .map((t) => OrderItemToppingsCompanion.insert(
                orderItemId: 0, // will be replaced by DAO
                subProductId: t.subProduct.id,
                subProductName: t.subProduct.name,
                unitPrice: t.subProduct.price,
                quantity: Value(t.quantity),
              ))
          .toList();
      return (item: item, toppings: toppingCompanions);
    }).toList();
  }
}
