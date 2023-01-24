import 'package:final_project/renkler.dart';
import 'package:final_project/ui/cubit/login_cubit.dart';
import 'package:final_project/ui/cubit/sepet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Onay extends StatefulWidget {
  int toplamTutar;
  String odemeTipi;
  Onay(this.toplamTutar,this.odemeTipi, {super.key});

  @override
  State<Onay> createState() => _OnayState();
}

class _OnayState extends State<Onay> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Future.delayed(const Duration(seconds: 7),
        AnasayfayaDon,
      );
    });
  }
  void AnasayfayaDon () async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.read<SepetCubit>().sepetListele(context.read<LoginCubit>().klc);
  }
  @override
  Widget build(BuildContext context) {
    final double ekranGenislik = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: anatema,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Siparişiniz Onaylandı",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
                shadows: const [Shadow(color: Colors.red,blurRadius: 5 ,offset: Offset(0.9, 0.3))],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            SvgPicture.asset('assets/sepet_asset/motocycle.svg',
              height: 120,
              width: 120,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ekranGenislik / 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Ödenecek Tutar ",
                        style: TextStyle(
                          fontSize: ekranGenislik / 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          shadows: const [Shadow(color: Colors.red,blurRadius: 4 ,offset: Offset(0.9, 0.3))],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text("${widget.toplamTutar} ₺",style: TextStyle(
                        fontSize: ekranGenislik / 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [Shadow(color: Colors.red,blurRadius: 4 ,offset: Offset(0.9, 0.3))],
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Ödeme Tipi ",
                        style: TextStyle(
                          fontSize: ekranGenislik / 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          shadows: const [Shadow(color: Colors.red,blurRadius: 4 ,offset: Offset(0.9, 0.3))],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text(widget.odemeTipi,style: TextStyle(
                        fontSize: ekranGenislik / 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [Shadow(color: Colors.red,blurRadius: 4 ,offset: Offset(0.9, 0.3))],
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Adres ",style: TextStyle(
                        fontSize: ekranGenislik / 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [Shadow(color: Colors.red,blurRadius: 4 ,offset: Offset(0.9, 0.3))],
                      ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text(context.read<LoginCubit>().adres.length >= 13 ? "${context.read<LoginCubit>().adres.substring(0,13)}.." : context.read<LoginCubit>().adres,style: TextStyle(
                        fontSize: ekranGenislik / 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [Shadow(color: Colors.red,blurRadius: 4,offset: Offset(0.9, 0.3))],
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
