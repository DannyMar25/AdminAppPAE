import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  String get token {
    return _prefs!.getString('token') ?? '';
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }
  //Email y rol

  String get email {
    return _prefs!.getString('email') ?? '';
  }

  void setEmail(String value) {
    _prefs!.setString('email', value);
  }

  void removeEmail() {
    _prefs!.remove('email');
  }

  String get rol {
    return _prefs!.getString('rol') ?? '';
  }

  void setRol(String value) {
    _prefs!.setString('rol', value);
  }

  void removeRol() {
    _prefs!.remove('rol');
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs!.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs!.setString('ultimaPagina', value);
  }
}
