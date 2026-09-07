import 'package:final_project/data/entity/food.dart';
import 'package:final_project/data/repository/food_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailCubit extends Cubit<void> {
  FoodDetailCubit() : super(null);

  final FoodRepository _repository = FoodRepository();

  Future<void> addToCart({required Food food, required int quantity, required String username}) async {
    await _repository.addToCart(food: food, quantity: quantity, username: username);
  }
}
