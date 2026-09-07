/// A food item in the user's cart. JSON keys follow the remote API contract.
class CartItem {
  final String cartItemId;
  final String quantity;
  final String username;
  final String foodName;
  final String imageName;
  final String price;

  const CartItem({
    required this.cartItemId,
    required this.quantity,
    required this.username,
    required this.foodName,
    required this.imageName,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json["sepet_yemek_id"] as String,
      quantity: json["yemek_siparis_adet"] as String,
      username: json["kullanici_adi"] as String,
      foodName: json["yemek_adi"] as String,
      imageName: json["yemek_resim_adi"] as String,
      price: json["yemek_fiyat"] as String,
    );
  }

  /// Line total: unit price multiplied by quantity.
  int get totalPrice => int.parse(price) * int.parse(quantity);
}
