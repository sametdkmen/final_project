import 'package:final_project/renkler.dart';
import 'package:final_project/ui/cubit/login_cubit.dart';
import 'package:final_project/ui/screen/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  var tfAd = TextEditingController();
  var tfSoyad = TextEditingController();
  var tfAdres = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: anatema,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.06),
                  const Text(
                    "Hoşgeldiniz",
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: tfAd,
                    style: const TextStyle(color: Colors.white70),
                    inputFormatters: [LengthLimitingTextInputFormatter(12)],
                    decoration: const InputDecoration(
                      labelText: "Adınızı girin",
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.white60),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Lütfen geçerli bir isim girin..";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: tfSoyad,
                    inputFormatters: [LengthLimitingTextInputFormatter(12)],
                    style: const TextStyle(color: Colors.white70),
                    decoration: const InputDecoration(
                      labelText: "Soyadınızı girin",
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.white60),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Lütfen geçerli bir soyisim girin..";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: tfAdres,
                    style: const TextStyle(color: Colors.white70),
                    inputFormatters: [LengthLimitingTextInputFormatter(35)],
                    decoration: const InputDecoration(
                      labelText: "Adres girin",
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.white60),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'\w').hasMatch(value)) {
                        return "Lütfen geçerli bir adres girin..";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Devam Et",
                        style: TextStyle(fontSize: 26, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            String ad = tfAd.text;
                            String soyad = tfSoyad.text;
                            String adres = tfAdres.text;
                            ///////////////////////////////////////////////////////////////////
                            String logiName = ("${ad.toLowerCase().replaceAll(" ", "")}_${soyad.toLowerCase().replaceAll(" ", "")}");
                            String adresTut = (adres.toLowerCase());
                            print("Login name : $logiName");
                            context.read<LoginCubit>().klc = logiName;
                            context.read<LoginCubit>().adres = adresTut;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Anasayfa()));
                          }
                        },
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
        ));
  }
}
