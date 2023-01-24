import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YemekDetayCubit extends Cubit<void> {
  YemekDetayCubit():super(0);

  var yemekrepo = YemekRepository();

  Future<void> yemekEkle(String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet,String kullanici_adi) async{
    await yemekrepo.yemekEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
    await yemekrepo.sepetListele(kullanici_adi);
  }

}