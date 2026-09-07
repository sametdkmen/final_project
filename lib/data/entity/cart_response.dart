import 'package:final_project/data/entity/cart_item.dart';

/// Response envelope of the "get cart" endpoint.
class CartResponse {
  final List<CartItem> items;
  final int success;

  const CartResponse({required this.items, required this.success});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final jsonArray = json["sepet_yemekler"] as List;
    return CartResponse(
      items: jsonArray.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList(),
      success: json["success"] as int,
    );
  }
}
