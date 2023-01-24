import 'package:final_project/data/entity/yemek/yemekler.dart';

class YemeklerCevap {
  List<Yemekler> yemekler;
  int success;

  YemeklerCevap({required this.yemekler,required this.success});

  factory YemeklerCevap.fromJson(Map<String,dynamic> json) {
    var jsonArray = json["yemekler"] as List;
    var yemekler = jsonArray.map((e) => Yemekler.fromJson(e)).toList();

    return YemeklerCevap(
        yemekler: yemekler,
        success: json["success"] as int
    );


  }
}