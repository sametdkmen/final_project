import 'package:final_project/data/entity/cart_item.dart';
import 'package:final_project/data/repository/food_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cart contents plus whether they have been fetched at least once, so the UI
/// can tell "still loading" apart from "cart is empty".
class CartState {
  final List<CartItem> items;
  final bool isLoaded;

  const CartState({this.items = const [], this.isLoaded = false});

  int get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  final FoodRepository _repository = FoodRepository();

  Future<void> loadCart(String username) async {
    final items = await _repository.getCart(username);
    emit(CartState(items: items, isLoaded: true));
  }

  Future<void> removeItem(int cartItemId, String username) async {
    await _repository.removeFromCart(cartItemId, username);
    await loadCart(username);
  }

  /// Removes every item in the cart (used when an order is confirmed).
  Future<void> clear(String username) async {
    for (final item in state.items) {
      await _repository.removeFromCart(int.parse(item.cartItemId), username);
    }
    await loadCart(username);
  }
}
