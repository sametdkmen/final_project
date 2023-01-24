import 'package:final_project/data/repo/yemekrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<void> {
  LoginCubit():super(0);
  String klc = "";
  String adres = "";
  var repo = YemekRepository();

}