import 'dart:convert';
import 'package:final_project/data/entity/sepet/sepet_yemekler.dart';
import 'package:final_project/data/entity/sepet/sepet_yemekler_cevap.dart';
import 'package:final_project/data/entity/yemek/yemekler.dart';
import 'package:final_project/data/entity/yemek/yemekler_cevap.dart';
import 'package:dio/dio.dart';

class YemekRepository {
  final String hataEngelle =
      '{"sepet_yemekler":[{"sepet_yemek_id":"","yemek_adi":"bosliste","yemek_resim_adi":"","yemek_fiyat":"","yemek_siparis_adet":"","kullanici_adi":""}],"success":1}';
  static String aranan = '';
  final String yemekleriGetirURL =
      "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
  final String sepeteYemekEkleURL =
      "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
  final String sepettenYemekSilURL =
      "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
  final String sepettekiYemekleriGetirURL =
      "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
  static bool varMi = false;
  static bool bosListeGeldi = false;
  int sepetyid = 0;

  void parseEt(String yemekadi) async {
    if (aranan.contains('\n\n\n\n\n')) {
      print("parse et metoduna boş cevap geldi");
      bosListeGeldi = true;
      print('boş liste geldi : $bosListeGeldi');
    } else {
      bosListeGeldi = false;
      var jsonVeri = json.decode(aranan);
      var jsonArray = jsonVeri["sepet_yemekler"] as List;
      List<SepetYemekler> aramaListesi =
      jsonArray.map((e) => SepetYemekler.fromJson(e)).toList();

      for (var k in aramaListesi) {
        print("----------------");
        print(
            "var mı ? : ${k.yemek_adi} - ${k.yemek_adi.contains(yemekadi)} - ${k.sepet_yemek_id}");
        if (k.yemek_adi.contains(yemekadi)) {
          print("bu yemek varmış -- adı : ${k.yemek_adi} - ${k.yemek_adi.contains(yemekadi)} - id : ${k.sepet_yemek_id}");
          varMi = true;
          sepetyid = int.parse(k.sepet_yemek_id);
          print("sepet_yemek_id degiskene aktarıldı : $sepetyid");
          break;
        } else {
          varMi = false;
          print(
              "bu yemek yokmuş,ekleniyor.. --  ${k.yemek_adi} -- ${k.sepet_yemek_id}");
        }
      }
    }
  }

  Future<void> yemekEkle(String yemek_adi, String yemek_resim_adi,
      int yemek_fiyat, int yemek_siparis_adet, String kullanici_adi) async {
    parseEt(yemek_adi);
    if (varMi == true) {
      print("bu yemek olduğu için yeniden eklenemedi,bunun yerine adet güncelleyelim.");
      dogrudanYemekEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
      await sil(sepetyid, kullanici_adi);
    } else if (varMi == false) {
      await dogrudanYemekEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
    }
  }

  Future<void> dogrudanYemekEkle(String yemek_adi, String yemek_resim_adi,
      int yemek_fiyat, int yemek_siparis_adet, String kullanici_adi) async {
    var url = sepeteYemekEkleURL;
    var veri = {
      "yemek_adi": yemek_adi,
      "yemek_resim_adi": yemek_resim_adi,
      "yemek_fiyat": yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("yemek kayıt : ${cevap.data.toString()}");
    bosListeGeldi = false;
  }

  Future<void> sil(int sepet_yemek_id, String kullanici_adi) async {
    var url = sepettenYemekSilURL;
    var veri = {
      "sepet_yemek_id": sepet_yemek_id,
      "kullanici_adi": kullanici_adi
    };
    await Dio().post(url, data: FormData.fromMap(veri));
  }

  List<Yemekler> parseYemeklerCevap(String cevap) {
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  Future<List<Yemekler>> yemekleriListele() async {
    var url = yemekleriGetirURL; //urlyi buraya yerleştirdik.
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

  List<SepetYemekler> parseSepetYemeklerCevap(String cevap2) {
    if (cevap2.contains('\n\n\n\n\n')) {
      varMi = false;
      bosListeGeldi = true;
      print(
          "cevap null geldi -- bosListeGeldi : $bosListeGeldi -- yemekVarMi : $varMi");
      return SepetCevap.fromJson(json.decode(hataEngelle)).sepet_yemekler;
    }
    return SepetCevap.fromJson(json.decode(cevap2)).sepet_yemekler;
  }

  Future<List<SepetYemekler>> sepetListele(String kullanici_adi) async {
    var url = sepettekiYemekleriGetirURL; //urlyi buraya yerleştirdik.
    var veri = {"kullanici_adi": kullanici_adi};
    var cevap2 = await Dio().post(url, data: FormData.fromMap(veri));
    aranan = cevap2.data;
    return parseSepetYemeklerCevap(cevap2.data.toString());
  }


}