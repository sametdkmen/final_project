import 'package:final_project/core/api_constants.dart';
import 'package:final_project/core/app_colors.dart';
import 'package:final_project/data/entity/food.dart';
import 'package:final_project/ui/cubit/cart_cubit.dart';
import 'package:final_project/ui/cubit/home_cubit.dart';
import 'package:final_project/ui/cubit/session_cubit.dart';
import 'package:final_project/ui/screens/cart_screen.dart';
import 'package:final_project/ui/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menu grid with a cart badge in the app bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadFoods();
    context.read<CartCubit>().loadCart(context.read<SessionCubit>().state.username);
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final session = context.watch<SessionCubit>().state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 3),
            Text("Lezzet Durağı", style: TextStyle(fontSize: screenWidth / 22, color: Colors.white)),
            Text(
              session.shortAddress(16),
              style: TextStyle(fontSize: screenWidth / 24, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cart) {
              if (cart.items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    onPressed: _openCart,
                    icon: const Icon(Icons.shopping_basket),
                    color: AppColors.textPrimary,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: _openCart,
                      icon: const Icon(Icons.shopping_basket),
                      color: Colors.grey,
                    ),
                    Container(
                      height: screenWidth / 20,
                      width: screenWidth / 20,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          cart.items.length.toString(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: screenWidth / 27,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<HomeCubit, List<Food>>(
          builder: (context, foods) {
            if (foods.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.black54));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodDetailScreen(food: food)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
                      child: Container(
                        height: screenHeight / 2,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              height: screenHeight / 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(blurRadius: 5, color: Colors.white.withValues(alpha: 0.9)),
                                ],
                              ),
                              child: Image.network(ApiConstants.foodImageUrl(food.imageName)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.name,
                              style: TextStyle(
                                fontSize: screenHeight / 44,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 6, offset: const Offset(1, 1)),
                                ],
                              ),
                            ),
                            Text(
                              "${food.price} ₺",
                              style: TextStyle(
                                fontSize: screenHeight / 46,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 2, offset: const Offset(0.5, 0.5)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
