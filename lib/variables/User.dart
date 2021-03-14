import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String nombre;
  String avatar;
  String garrafonesVendidos;
  String puntos;
  bool isLogin;
  bool themeLight;

  void initial() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    //isloginkey == true o isLogin != null o isLogin == true => ya esta logeado;
    if (disk.getBool('isloginkey') != null &&
        disk.getBool('isloginkey') == true) {
      setnombre = disk.getString('nombrekey');
      setavatar = disk.getString('avatarkey');
      setisLogin = (disk.getBool('isloginkey') ?? true);
      print("Logeado como = " +
          disk.getString('nombrekey') +
          disk.getString('avatarkey'));
    }
  }
  // SETTERS OF REPARTIDORES */

  set setnombre(data) {
    this.nombre = data;
    notifyListeners();
  }

  set setavatar(data) {
    this.avatar = data;
    notifyListeners();
  }

  set setgarrafonesvendidos(data) {
    this.garrafonesVendidos = data;
    notifyListeners();
  }

  set setpuntos(data) {
    this.puntos = data;
    notifyListeners();
  }

  set setisLogin(data) {
    this.isLogin = data;
    notifyListeners();
  }

  set setTheme(data) {
    this.themeLight = data;
    notifyListeners();
  }

  /// GETTERS OF REPARTIDORES  */

  String get getnombre => this.nombre;
  String get getavatar => this.avatar;
  String get getgarrafonesvendidos => this.garrafonesVendidos;
  String get getpuntos => this.garrafonesVendidos;
  bool get getisLogin => this.isLogin;
  bool get geThemeLigth => this.themeLight;
}
