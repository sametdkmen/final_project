/// A food item from the menu. JSON keys follow the remote API contract.
class Food {
  final String id;
  final String name;
  final String imageName;
  final String price;

  const Food({
    required this.id,
    required this.name,
    required this.imageName,
    required this.price,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json["yemek_id"] as String,
      name: json["yemek_adi"] as String,
      imageName: json["yemek_resim_adi"] as String,
      price: json["yemek_fiyat"] as String,
    );
  }
}
