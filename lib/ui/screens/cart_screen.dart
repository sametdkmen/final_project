import 'package:final_project/core/api_constants.dart';
import 'package:final_project/core/app_colors.dart';
import 'package:final_project/data/entity/cart_item.dart';
import 'package:final_project/ui/cubit/cart_cubit.dart';
import 'package:final_project/ui/cubit/session_cubit.dart';
import 'package:final_project/ui/screens/order_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Lists the cart, lets the user remove items, pick a payment method and
/// confirm the order.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const List<String> paymentMethods = ['Kredi Kartı', 'Nakit', 'Online Ödeme'];

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedPaymentMethod = CartScreen.paymentMethods.first;

  String get _username => context.read<SessionCubit>().state.username;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart(_username);
  }

  Future<void> _confirmOrder(int totalPrice) async {
    final cartCubit = context.read<CartCubit>();
    final navigator = Navigator.of(context);
    final username = _username;
    navigator.push(
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          totalPrice: totalPrice,
          paymentMethod: selectedPaymentMethod,
        ),
      ),
    );
    await cartCubit.clear(username);
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
        title: Text(
          "Sepetim",
          style: TextStyle(color: AppColors.textPrimary, fontSize: screenWidth / 19, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.textPrimary,
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cart) {
              if (!cart.isLoaded) {
                return SizedBox(
                  width: screenWidth,
                  height: screenHeight / 2,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Veriler Yükleniyor.."),
                      SizedBox(height: 30),
                      CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.grey),
                    ],
                  ),
                );
              }
              if (cart.items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight / 2.8,
                    horizontal: screenWidth > 400 ? screenWidth / 4 : screenWidth / 3.5,
                  ),
                  child: Column(
                    children: [
                      Text("Sepete Ürün Ekleyin", style: TextStyle(fontSize: screenWidth / 19)),
                      const SizedBox(height: 20),
                      SvgPicture.asset('assets/images/empty_cart.svg', height: 40, width: 40),
                    ],
                  ),
                );
              }
              return SizedBox(
                height: screenHeight > 800 ? screenHeight / 1.48 : screenHeight / 1.6,
                width: screenWidth,
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) => _CartItemTile(
                    item: cart.items[index],
                    onRemove: () => context
                        .read<CartCubit>()
                        .removeItem(int.parse(cart.items[index].cartItemId), _username),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: SizedBox(
        height: 180,
        width: screenWidth,
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            if (cart.items.isEmpty) return const SizedBox.shrink();
            final int totalPrice = cart.totalPrice;
            return Container(
              height: screenHeight / 4.443,
              width: screenWidth,
              padding: EdgeInsets.symmetric(vertical: screenHeight / 26, horizontal: screenWidth / 22),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _SummaryLabel("Ödeme Tipi", fontSize: screenWidth / 31),
                      const Spacer(),
                      DropdownButton<String>(
                        value: selectedPaymentMethod,
                        underline: const SizedBox(),
                        iconSize: 16,
                        icon: const Icon(Icons.shopping_cart_checkout),
                        iconEnabledColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: screenWidth / 14,
                        isDense: true,
                        dropdownColor: AppColors.primary,
                        alignment: Alignment.topCenter,
                        style: const TextStyle(color: Colors.white, fontSize: 5),
                        onChanged: (String? value) {
                          if (value == null) return;
                          setState(() => selectedPaymentMethod = value);
                        },
                        items: CartScreen.paymentMethods.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              child: _SummaryLabel(value, fontSize: screenWidth / 32),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _SummaryLabel("Adres", fontSize: screenWidth / 32),
                      const Spacer(),
                      _SummaryLabel(session.shortAddress(13), fontSize: screenWidth / 32),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _SummaryLabel("Toplam (KDV Dahil)", fontSize: screenWidth / 40),
                      const Spacer(),
                      _SummaryLabel("$totalPrice ₺", fontSize: screenWidth / 40),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: screenHeight / 20,
                    width: screenWidth / 1.1,
                    child: ElevatedButton(
                      onPressed: () => _confirmOrder(totalPrice),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: Text(
                        "Sepeti Onayla",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryLabel extends StatelessWidget {
  final String text;
  final double fontSize;

  const _SummaryLabel(this.text, {required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 6, offset: const Offset(1, 1))],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const _CartItemTile({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        width: screenWidth,
        height: screenHeight / 7.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.primary,
          boxShadow: [BoxShadow(blurRadius: 15, color: Colors.grey.withValues(alpha: 0.5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 29),
              child: CircleAvatar(
                maxRadius: screenWidth / 13,
                minRadius: screenWidth / 13,
                backgroundColor: Colors.blueGrey.withAlpha(20),
                child: Image.network(ApiConstants.foodImageUrl(item.imageName)),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 25, color: AppColors.textPrimary),
                ),
                Text(
                  "${item.quantity} adet ",
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: screenWidth / 29),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle),
                  color: AppColors.textPrimary,
                  iconSize: 28,
                  alignment: Alignment.topRight,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 10.0),
                  child: Container(
                    width: 80,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white10.withValues(alpha: 0.6),
                      boxShadow: [BoxShadow(blurRadius: 15, color: Colors.white12.withValues(alpha: 0.1))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        "${item.totalPrice} ₺",
                        style: TextStyle(
                          fontSize: screenWidth / 25,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                          shadows: const [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0.7, 0.3))],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
