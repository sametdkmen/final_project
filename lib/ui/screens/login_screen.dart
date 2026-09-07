import 'package:final_project/core/app_colors.dart';
import 'package:final_project/ui/cubit/session_cubit.dart';
import 'package:final_project/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Collects the user's name and delivery address. There is no real
/// authentication; the values only identify the cart on the API.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();

  static final RegExp _lettersOnly = RegExp(r'^[a-z A-Z]+$');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SessionCubit>().login(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          address: _addressController.text,
        );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.06),
                const Text("Hoşgeldiniz", style: TextStyle(fontSize: 28, color: Colors.white)),
                const SizedBox(height: 50),
                _LoginField(
                  controller: _firstNameController,
                  label: "Adınızı girin",
                  maxLength: 12,
                  validator: (value) =>
                      value == null || value.isEmpty || !_lettersOnly.hasMatch(value)
                          ? "Lütfen geçerli bir isim girin.."
                          : null,
                ),
                _LoginField(
                  controller: _lastNameController,
                  label: "Soyadınızı girin",
                  maxLength: 12,
                  validator: (value) =>
                      value == null || value.isEmpty || !_lettersOnly.hasMatch(value)
                          ? "Lütfen geçerli bir soyisim girin.."
                          : null,
                ),
                _LoginField(
                  controller: _addressController,
                  label: "Adres girin",
                  maxLength: 35,
                  validator: (value) =>
                      value == null || value.isEmpty || !RegExp(r'\w').hasMatch(value)
                          ? "Lütfen geçerli bir adres girin.."
                          : null,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Devam Et", style: TextStyle(fontSize: 26, color: Colors.white)),
                    IconButton(
                      onPressed: _submit,
                      icon: const Icon(Icons.arrow_circle_right_sharp),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLength;
  final FormFieldValidator<String> validator;

  const _LoginField({
    required this.controller,
    required this.label,
    required this.maxLength,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white70),
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        errorStyle: const TextStyle(color: Colors.white60),
      ),
      validator: validator,
    );
  }
}
