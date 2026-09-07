import 'package:final_project/data/entity/food.dart';

/// Response envelope of the "get all foods" endpoint.
class FoodResponse {
  final List<Food> foods;
  final int success;

  const FoodResponse({required this.foods, required this.success});

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    final jsonArray = json["yemekler"] as List;
    return FoodResponse(
      foods: jsonArray.map((e) => Food.fromJson(e as Map<String, dynamic>)).toList(),
      success: json["success"] as int,
    );
  }
}
