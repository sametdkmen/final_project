import 'package:final_project/data/entity/sepet/sepet_yemekler.dart';
import 'package:final_project/data/entity/yemek/yemekler.dart';
import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:final_project/renkler.dart';
import 'package:final_project/ui/cubit/anasayfa_cubit.dart';
import 'package:final_project/ui/cubit/login_cubit.dart';
import 'package:final_project/ui/cubit/sepet_cubit.dart';
import 'package:final_project/ui/screen/sepet_sayfa.dart';
import 'package:final_project/ui/screen/yemek_detay_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  @override
  void initState() {
    super.initState();
    setState(() {
      context.read<AnasayfaCubit>().yemekleriListele();
    });
  }
  @override
  Widget build(BuildContext context) {
    context.read<SepetCubit>().sepetListele(context.read<LoginCubit>().klc);
    var ekranBilgi = MediaQuery.of(context);
    double ekranGenislik = ekranBilgi.size.width;
    double ekranYukseklik = ekranBilgi.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: anatema,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 3),
            Text(
              "Lezzet Durağı",
              style: TextStyle(fontSize: ekranGenislik / 22, color: Colors.white),
            ),
              Text(context.read<LoginCubit>().adres.length >= 16 ? "${context.read<LoginCubit>().adres.substring(0,16)}.." : context.read<LoginCubit>().adres,
              style: TextStyle(fontSize: ekranGenislik / 24,color: Colors.white54),
            ),
          ],
        ),
        actions: [
          BlocBuilder<SepetCubit, List<SepetYemekler>>(
            builder: (context, sepeturunlerListesi) {
              if (sepeturunlerListesi.length > 0 &&
                  YemekRepository.bosListeGeldi == false) {
                print("sepetteki : ${sepeturunlerListesi.length}");
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Stack(children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SepetSayfa()));
                        });
                      },
                      icon: const Icon(Icons.shopping_basket),
                      color: Colors.grey,
                    ),
                    Container(
                      height: ekranGenislik / 20,
                      width: ekranGenislik / 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          sepeturunlerListesi.length.toString(),
                          style: TextStyle(
                              color: anatema,
                              fontSize: ekranGenislik / 27,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SepetSayfa()));
                    },
                    icon: const Icon(Icons.shopping_basket),
                    color: yazirenk,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<AnasayfaCubit,List<Yemekler>>(
            builder: (context,yemekListesi){
             if(yemekListesi.isNotEmpty){
               return Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: GridView.builder(
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                     itemCount: yemekListesi.length,
                     itemBuilder: (context,index){
                       var yemek = yemekListesi[index];
                       return GestureDetector(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => YemekDetaySayfa(yemek: yemek)));
                         },
                         child: Padding(
                           padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 6),
                           child: Container(
                             height: ekranYukseklik / 2,
                             width: ekranGenislik,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               color: anatema,
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 const SizedBox(height: 4),
                                 Container(
                                   height: ekranYukseklik / 8,
                                     decoration: BoxDecoration(shape: BoxShape.circle
                                         ,color: Colors.white, boxShadow: [
                                         BoxShadow(
                                           blurRadius: 5,
                                           color: Colors.white.withOpacity(0.9),
                                         ),
                                       ],),
                                     child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}")),
                                 const SizedBox(height: 4),
                                 Text(yemek.yemek_adi,style: TextStyle(fontSize: ekranYukseklik / 44,fontWeight: FontWeight.bold,color: Colors.white,shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 6, offset: const Offset(1, 1))]),),
                                 Text("${yemek.yemek_fiyat} ₺",style: TextStyle(fontSize: ekranYukseklik / 46,color: Colors.white,shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 2, offset: const Offset(0.5, 0.5))],),),
                               ],
                             ),
                           ),
                         ),
                       );
                     }
                 ),
               );
             }
             else
             {
               return const Center(
                   child: CircularProgressIndicator(
                     color: Colors.black54,
                   ),
               );
             }
            }
        ),
      ),
    );
  }
}

