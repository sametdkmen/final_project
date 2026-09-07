import 'package:final_project/core/app_colors.dart';
import 'package:final_project/ui/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shown after the order is confirmed; returns to the home screen automatically.
class OrderConfirmationScreen extends StatefulWidget {
  final int totalPrice;
  final String paymentMethod;

  const OrderConfirmationScreen({
    super.key,
    required this.totalPrice,
    required this.paymentMethod,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 7), () {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final session = context.watch<SessionCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Siparişiniz Onaylandı",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
                shadows: const [Shadow(color: Colors.red, blurRadius: 5, offset: Offset(0.9, 0.3))],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SvgPicture.asset('assets/images/motorcycle.svg', height: 120, width: 120),
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 12.0),
              child: Column(
                children: [
                  _SummaryRow(label: "Ödenecek Tutar ", value: "${widget.totalPrice} ₺", screenWidth: screenWidth),
                  const SizedBox(height: 15),
                  _SummaryRow(label: "Ödeme Tipi ", value: widget.paymentMethod, screenWidth: screenWidth),
                  const SizedBox(height: 15),
                  _SummaryRow(label: "Adres ", value: session.shortAddress(13), screenWidth: screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final double screenWidth;

  const _SummaryRow({required this.label, required this.value, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: screenWidth / 26,
      fontWeight: FontWeight.bold,
      color: Colors.white.withValues(alpha: 0.9),
      shadows: const [Shadow(color: Colors.red, blurRadius: 4, offset: Offset(0.9, 0.3))],
    );
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style, textAlign: TextAlign.center),
      ],
    );
  }
}
