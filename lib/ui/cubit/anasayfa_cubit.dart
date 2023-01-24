import 'package:final_project/data/entity/yemek/yemekler.dart';
import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnasayfaCubit extends Cubit<List<Yemekler>>{
  AnasayfaCubit() : super(<Yemekler>[]);

  var yemekrepo = YemekRepository();

  Future<void> yemekleriListele() async {
    var liste = await yemekrepo.yemekleriListele();
    emit(liste);
  }






}