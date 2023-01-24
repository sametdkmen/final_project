import 'package:final_project/renkler.dart';
import 'package:final_project/ui/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: anatema,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/sepet_asset/food.svg",
              height: 130,
              width: 130,
            ),
            const SizedBox(height: 30),
            const Text("Lezzet Durağı",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
