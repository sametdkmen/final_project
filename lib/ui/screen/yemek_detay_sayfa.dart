import 'package:final_project/data/entity/yemek/yemekler.dart';
import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:final_project/renkler.dart';
import 'package:final_project/ui/cubit/login_cubit.dart';
import 'package:final_project/ui/cubit/sepet_cubit.dart';
import 'package:final_project/ui/cubit/yemek_detay_cubit.dart';
import 'package:final_project/ui/screen/sepet_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YemekDetaySayfa extends StatefulWidget {
  Yemekler yemek;

  YemekDetaySayfa({super.key, required this.yemek});

  static const List<String> liste = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  State<YemekDetaySayfa> createState() => _YemekDetaySayfaState();
}

class _YemekDetaySayfaState extends State<YemekDetaySayfa> {
  String dropdownValue = YemekDetaySayfa.liste.first;
  var k = YemekRepository();
  int adet = 0;
  @override
  Widget build(BuildContext context) {
    var yemekD = widget.yemek;
    var ekranBilgi = MediaQuery.of(context);
    final double ekranGenislik = ekranBilgi.size.width;
    final double ekranYukseklik = ekranBilgi.size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: anatema,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              "Lezzet Durağı",
              style: TextStyle(fontSize: ekranGenislik / 22, color: Colors.white),
            ),
            Text(
              context.read<LoginCubit>().adres,
              style: TextStyle(fontSize: ekranGenislik / 24, color: Colors.white54),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.arrow_back_ios),color: yazirenk),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ekranYukseklik / 7),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: ekranYukseklik / 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ekranGenislik / 14.0),
                    child: Container(
                        height: ekranYukseklik / 3.8,
                        width: ekranGenislik,
                        decoration: BoxDecoration(
                          color: anatema,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.network(
                            "http://kasimadalan.pe.hu/yemekler/resimler/${yemekD.yemek_resim_adi}"),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    yemekD.yemek_adi,
                    style: TextStyle(
                      fontSize: ekranGenislik / 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withAlpha(215),
                      shadows: const [Shadow(color: Colors.grey,blurRadius: 4 ,offset: Offset(0.9, 1))],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 90,
                    height: ekranYukseklik / 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      underline: const SizedBox(),
                      iconSize: 24,
                      icon: const Icon(Icons.add_circle_outline),
                      iconEnabledColor: anatema,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      menuMaxHeight: ekranGenislik / 10,
                      isDense: true,
                      elevation: 0,
                      alignment: Alignment.centerRight,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black, fontSize: 8),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: YemekDetaySayfa.liste
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                            child: Text(value,style: TextStyle(
                              color: Colors.black,
                              fontSize: ekranGenislik / 24,
                              overflow: TextOverflow.visible,
                              height: ekranYukseklik > 800 ? 1 : 0.925,
                              fontWeight: FontWeight.bold,
                            ),),
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
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: anatema,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ekranGenislik / 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Genel Toplam ",style: TextStyle(fontSize: ekranGenislik / 33,fontWeight: FontWeight.normal,color: Colors.white,shadows: [Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 3, offset: const Offset(1, 1))]),),
                  const SizedBox(
                    width: 4,
                  ),
                  Text("${(int.parse(yemekD.yemek_fiyat) * int.parse(dropdownValue))} ₺",style: TextStyle(fontSize: ekranGenislik / 33,fontWeight: FontWeight.normal,color: Colors.white,shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))]),),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      context.read<YemekDetayCubit>().yemekEkle(yemekD.yemek_adi,
                          yemekD.yemek_resim_adi,
                          int.parse(yemekD.yemek_fiyat),
                          int.parse(dropdownValue),
                          context.read<LoginCubit>().klc);
                      anasayfayaDon();
                    });

                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    "Sepete Ekle",
                    style: TextStyle(fontSize: ekranYukseklik / 45,fontWeight: FontWeight.bold,color: anatema,shadows: [Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0.6, 0.8))]),), //buton rengini verdik.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> anasayfayaDon () async {
    context.read<SepetCubit>().sepetListele(context
        .read<LoginCubit>()
        .klc);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

