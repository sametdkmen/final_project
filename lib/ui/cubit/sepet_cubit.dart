import 'package:final_project/data/entity/sepet/sepet_yemekler.dart';
import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SepetCubit extends Cubit<List<SepetYemekler>> {
  SepetCubit():super(<SepetYemekler>[]);

  var yemekrepo = YemekRepository();

  int genelToplam = 0;

  Future<void> sepetListele (String kullanici_adi) async {
    var liste = await yemekrepo.sepetListele(kullanici_adi);
    emit(liste);
  }


  Future<void> sil (int sepet_yemek_id, String kullanici_adi) async {
    await yemekrepo.sil(sepet_yemek_id,kullanici_adi);
  }

}