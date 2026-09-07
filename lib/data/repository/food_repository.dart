import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project/core/api_constants.dart';
import 'package:final_project/data/entity/cart_item.dart';
import 'package:final_project/data/entity/cart_response.dart';
import 'package:final_project/data/entity/food.dart';
import 'package:final_project/data/entity/food_response.dart';

/// Talks to the remote food-ordering API.
class FoodRepository {
  final Dio _dio = Dio();

  Future<List<Food>> getAllFoods() async {
    final response = await _dio.get(ApiConstants.getAllFoods);
    return FoodResponse.fromJson(json.decode(response.data.toString())).foods;
  }

  /// Returns the cart of [username]. The API answers with an empty body
  /// (only whitespace) instead of an empty list when the cart is empty.
  Future<List<CartItem>> getCart(String username) async {
    final response = await _dio.post(
      ApiConstants.getCart,
      data: FormData.fromMap({"kullanici_adi": username}),
    );
    final body = response.data.toString();
    if (body.trim().isEmpty) {
      return const [];
    }
    return CartResponse.fromJson(json.decode(body)).items;
  }

  /// Adds [food] to the cart with the given [quantity]. If the same food is
  /// already in the cart, the old row is removed so the new quantity replaces it.
  Future<void> addToCart({
    required Food food,
    required int quantity,
    required String username,
  }) async {
    final existingItems = await getCart(username);
    final CartItem? existing = existingItems
        .where((item) => item.foodName == food.name)
        .cast<CartItem?>()
        .firstWhere((_) => true, orElse: () => null);

    await _dio.post(
      ApiConstants.addToCart,
      data: FormData.fromMap({
        "yemek_adi": food.name,
        "yemek_resim_adi": food.imageName,
        "yemek_fiyat": int.parse(food.price),
        "yemek_siparis_adet": quantity,
        "kullanici_adi": username,
      }),
    );

    if (existing != null) {
      await removeFromCart(int.parse(existing.cartItemId), username);
    }
  }

  Future<void> removeFromCart(int cartItemId, String username) async {
    await _dio.post(
      ApiConstants.removeFromCart,
      data: FormData.fromMap({
        "sepet_yemek_id": cartItemId,
        "kullanici_adi": username,
      }),
    );
  }
}
