import 'package:shared_preferences/shared_preferences.dart';


class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  static SharedPreferences? _prefs;

    initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  int get tab{
    return _prefs!.getInt('tab') ?? 0;
  }

  set tab( int value ) {
    _prefs!.setInt('tab', value);
  }
  
 
  
   String get valcat{
    return _prefs!.getString('valcat') ?? "Todas las categorias";
  }

  set valcat( String value ) {
    _prefs!.setString('valcat', value);
  }
  
    int get codigo{
    return _prefs!.getInt('codigo') ?? 10000;
  }

  set codigo( int value ) {
    _prefs!.setInt('codigo', value);
  }

  
  bool get actual{
    return _prefs!.getBool('actual') ?? false;
  }

  set actual( bool value ) {
    _prefs!.setBool('actual', value);
  }


 String get error{
    return _prefs!.getString('error') ?? "";
  }

  set error( String value ) {
    _prefs!.setString('error', value);
  }
  
}

