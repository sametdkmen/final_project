import 'package:flutter_bloc/flutter_bloc.dart';

/// The user identity entered on the login screen.
class Session {
  final String username;
  final String address;

  const Session({this.username = "", this.address = ""});

  /// Address shortened for app bar titles.
  String shortAddress(int maxLength) =>
      address.length >= maxLength ? "${address.substring(0, maxLength)}.." : address;
}

class SessionCubit extends Cubit<Session> {
  SessionCubit() : super(const Session());

  void login({required String firstName, required String lastName, required String address}) {
    String normalize(String value) => value.toLowerCase().replaceAll(" ", "");
    emit(Session(
      username: "${normalize(firstName)}_${normalize(lastName)}",
      address: address.toLowerCase(),
    ));
  }
}
