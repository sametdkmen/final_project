import 'package:final_project/core/api_constants.dart';
import 'package:final_project/core/app_colors.dart';
import 'package:final_project/data/entity/food.dart';
import 'package:final_project/ui/cubit/cart_cubit.dart';
import 'package:final_project/ui/cubit/food_detail_cubit.dart';
import 'package:final_project/ui/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows one food with a quantity picker and an "add to cart" button.
class FoodDetailScreen extends StatefulWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  static const List<String> quantityOptions = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  String selectedQuantity = FoodDetailScreen.quantityOptions.first;

  int get totalPrice => int.parse(widget.food.price) * int.parse(selectedQuantity);

  Future<void> _addToCart() async {
    final username = context.read<SessionCubit>().state.username;
    final cartCubit = context.read<CartCubit>();
    final navigator = Navigator.of(context);

    await context.read<FoodDetailCubit>().addToCart(
          food: widget.food,
          quantity: int.parse(selectedQuantity),
          username: username,
        );
    await cartCubit.loadCart(username);
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final session = context.watch<SessionCubit>().state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text("Lezzet Durağı", style: TextStyle(fontSize: screenWidth / 22, color: Colors.white)),
            Text(session.address, style: TextStyle(fontSize: screenWidth / 24, color: Colors.white54)),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight / 7),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 14.0),
                    child: Container(
                      height: screenHeight / 3.8,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(ApiConstants.foodImageUrl(food.imageName)),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: screenWidth / 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withAlpha(215),
                      shadows: const [Shadow(color: Colors.grey, blurRadius: 4, offset: Offset(0.9, 1))],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 90,
                    height: screenHeight / 22,
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: selectedQuantity,
                      underline: const SizedBox(),
                      iconSize: 24,
                      icon: const Icon(Icons.add_circle_outline),
                      iconEnabledColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      menuMaxHeight: screenWidth / 10,
                      isDense: true,
                      elevation: 0,
                      alignment: Alignment.centerRight,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black, fontSize: 8),
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() => selectedQuantity = value);
                      },
                      items: FoodDetailScreen.quantityOptions.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth / 24,
                                overflow: TextOverflow.visible,
                                height: screenHeight > 800 ? 1 : 0.925,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: 130,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Genel Toplam ",
                    style: TextStyle(
                      fontSize: screenWidth / 33,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 3, offset: const Offset(1, 1))],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$totalPrice ₺",
                    style: TextStyle(
                      fontSize: screenWidth / 33,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 6, offset: const Offset(1, 1))],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    "Sepete Ekle",
                    style: TextStyle(
                      fontSize: screenHeight / 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0.6, 0.8))],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
