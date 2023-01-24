import 'sepet_yemekler.dart';

class SepetCevap {
  List<SepetYemekler> sepet_yemekler;
  int success;

  SepetCevap({required this.sepet_yemekler,required this.success});

  factory SepetCevap.fromJson(Map<String,dynamic> json){
    var jsonArray = json["sepet_yemekler"] as List;
    var sepet_yemekler = jsonArray.map((e) => SepetYemekler.fromJson(e)).toList();

    return SepetCevap(
    sepet_yemekler: sepet_yemekler,
    success: json["success"] as int
    );
  }
}