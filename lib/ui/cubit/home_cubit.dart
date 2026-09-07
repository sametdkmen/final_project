import 'package:final_project/data/entity/food.dart';
import 'package:final_project/data/repository/food_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the menu shown on the home screen.
class HomeCubit extends Cubit<List<Food>> {
  HomeCubit() : super(const <Food>[]);

  final FoodRepository _repository = FoodRepository();

  Future<void> loadFoods() async {
    emit(await _repository.getAllFoods());
  }
}
