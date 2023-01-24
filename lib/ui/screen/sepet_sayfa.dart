import 'package:final_project/data/entity/sepet/sepet_yemekler.dart';
import 'package:final_project/renkler.dart';
import 'package:final_project/ui/cubit/login_cubit.dart';
import 'package:final_project/ui/cubit/sepet_cubit.dart';
import 'package:final_project/ui/screen/onay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({super.key});
  static const List<String> odemeList = <String>[
    'Kredi Kartı',
    'Nakit',
    'Online Ödeme',
  ];

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {

  @override
  void initState() {
    super.initState();
    sepetListeleme;
  }

  void sepetListeleme () async {
    await context.read<SepetCubit>().sepetListele(context.read<LoginCubit>().klc);
  }

  bool tutarGoster = false;

  String dropdownValue = SepetSayfa.odemeList.first;

  @override
  Widget build(BuildContext context) {
    var ekranBilgi = MediaQuery.of(context);
    final double ekranGenislik = ekranBilgi.size.width;
    final double ekranYukseklik = ekranBilgi.size.height;
    print(ekranGenislik);
    print(ekranYukseklik);
    setState(() {
      sepetListeleme();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: anatema,
        elevation: 0,
        title: Text("Sepetim",style: TextStyle(color: yazirenk,fontSize: ekranGenislik / 19,fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.arrow_back_ios),color: yazirenk),
      ),
      body: Column(
        children: [
          BlocBuilder<SepetCubit, List<SepetYemekler>>(
            builder: (context, sepeturunlerListesi) {
              for (var k in sepeturunlerListesi) {
                if (k.yemek_adi.contains('bosliste')) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: ekranYukseklik / 2.8,horizontal: ekranGenislik > 400 ? ekranGenislik / 4 : ekranGenislik / 3.5),
                    child: Column(
                      children: [
                        Text(
                          "Sepete Ürün Ekleyin",
                          style: TextStyle(fontSize: ekranGenislik / 19),
                        ),
                        const SizedBox(height: 20),
                        SvgPicture.asset('assets/sepet_asset/bos_sepet.svg',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  );
                }
              }
              if (sepeturunlerListesi.isNotEmpty) {
                return SizedBox(
                  height: ekranYukseklik > 800 ? ekranYukseklik / 1.48 : ekranYukseklik / 1.6,  //emu 1.6 ideal - poco 1.48
                  width: ekranGenislik,
                  child: ListView.builder(
                    itemCount: sepeturunlerListesi.length,
                    itemBuilder: (context, index) {
                      var sepet = sepeturunlerListesi[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: ekranYukseklik / 7.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), //container kenarların yuvarlaklıgı
                                color: anatema, //container rengi
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ekranGenislik / 29),
                                    child: CircleAvatar(
                                      maxRadius: ekranGenislik / 13,
                                      minRadius: ekranGenislik / 13,
                                      backgroundColor: Colors.blueGrey.withAlpha(20),
                                      child: Image.network(
                                          "http://kasimadalan.pe.hu/yemekler/resimler/${sepet.yemek_resim_adi}"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    //eşit boşluklar yarattık.
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    //yazıları birbirine soldan hizaladık start noktasına getirdik.
                                    children: [
                                      Text(
                                        sepet.yemek_adi,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: ekranGenislik / 25,color: yazirenk),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${sepet.yemek_siparis_adet} adet ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,color: yazirenk,fontSize: ekranGenislik / 29),),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                            setState(() {
                                              context.read<SepetCubit>().sil(int.parse(sepet.sepet_yemek_id), sepet.kullanici_adi);
                                              sepetListeleme();
                                            });
                                        },
                                        icon: const Icon(
                                            Icons.remove_circle),color: yazirenk,iconSize: 28,alignment: Alignment.topRight),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0,right: 10.0),
                                        child: Container(
                                          width: 80,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            //container kenarların yuvarlaklıgı
                                            color: Colors.white10.withOpacity(0.6),
                                            //container rengi
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 15,
                                                color: Colors.white12
                                                    .withOpacity(0.1),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 3),
                                            child: Text(
                                              "${(int.parse(sepet.yemek_fiyat) * int.parse(sepet.yemek_siparis_adet))} ₺",
                                              style: TextStyle(
                                                fontSize: ekranGenislik / 25,
                                                overflow: TextOverflow.visible,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white.withOpacity(0.9),
                                                shadows: const [Shadow(color: Colors.black,blurRadius: 4 ,offset: Offset(0.7, 0.3))],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                return SizedBox(
                  width: ekranGenislik,
                  height: ekranYukseklik / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: const [
                          Text("Veriler Yükleniyor.."),
                          SizedBox(
                            height: 30,
                          ),
                          CircularProgressIndicator(
                            color: Colors.black,
                            backgroundColor: Colors.grey,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomSheet: Container(
        height: 180,
      width: ekranGenislik,
      color: Colors.transparent,
      child: BlocBuilder<SepetCubit, List<SepetYemekler>>(
        builder: (context, sepeturunlerListesi) {
          if(sepeturunlerListesi.length < 1){tutarGoster = false;}
          if (sepeturunlerListesi.length >= 2) {
            tutarGoster = true;
            int toplam = 0;
            for (var k in sepeturunlerListesi){
              toplam += (int.parse(k.yemek_fiyat)) * int.parse(k.yemek_siparis_adet);
            }
            return tutarGoster ? Container(
              height: ekranYukseklik / 4.443,
              width: ekranGenislik,
              padding: EdgeInsets.symmetric(vertical: ekranYukseklik / 26,horizontal: ekranGenislik / 22),
              decoration: BoxDecoration(
                color: anatema,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Ödeme Tipi",style: TextStyle(
                        color: Colors.white,
                        fontSize: ekranGenislik / 31,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                      ),),
                      const Spacer(),
                      DropdownButton<String>(
                        value: dropdownValue,
                        underline: const SizedBox(),
                        iconSize: 16,
                        icon: const Icon(Icons.shopping_cart_checkout),
                        iconEnabledColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {},
                        menuMaxHeight: ekranGenislik / 14,
                        isDense: true,
                        dropdownColor: anatema,
                        alignment: Alignment.topCenter,
                        style: const TextStyle(color: Colors.white, fontSize: 5),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: SepetSayfa.odemeList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                              child: Text(value,style: TextStyle(
                                color: Colors.white,
                                fontSize: ekranGenislik / 32,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                              ),),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text("Adres",style: TextStyle(
                        color: Colors.white,
                        fontSize: ekranGenislik / 32,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                      ),),
                      const Spacer(),
                      Text(context.read<LoginCubit>().adres.length >= 13 ? "${context.read<LoginCubit>().adres.substring(0,13)}.." : context.read<LoginCubit>().adres,style: TextStyle(
                        fontSize: ekranGenislik / 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                      ),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("Toplam (KDV Dahil)",style: TextStyle(
                            color: Colors.white,
                            fontSize: ekranGenislik / 40,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                          ),),
                          const Spacer(),
                          Text(
                            "${toplam.toString()} ₺",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ekranGenislik / 40,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height : 10),
                      SizedBox(
                        height: ekranYukseklik / 20,
                        width: ekranGenislik / 1.1,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for(var k in sepeturunlerListesi){
                                context.read<SepetCubit>().sil((int.parse(k.sepet_yemek_id)), k.kullanici_adi);
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Onay(toplam,dropdownValue)));
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: Text(
                            "Sepeti Onayla",
                            style: TextStyle(color: anatema,fontWeight: FontWeight.bold,fontSize: ekranGenislik / 28),
                          ), //buton rengini verdik.
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ) : const Text("");
          } else {
            return const Text("");
          }
        },
      ),
      ),
    );
  }
}

