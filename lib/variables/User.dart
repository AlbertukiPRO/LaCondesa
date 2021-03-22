import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  int idRepartidor;
  String nombre;
  String avatar;
  String garrafonesVendidos;
  String puntos;
  bool isLogin;
  bool themeLight = true;
  bool islectorQR = false;
  double preciogarrafon;
  double pay;
  // SETTERS OF REPARTIDORES */

  void initial() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    //isloginkey == true o isLogin != null o isLogin == true => ya esta logeado;
    if (disk.getBool('isloginkey') != null &&
        disk.getBool('isloginkey') == true) {}
  }

  set setid(data) {
    this.idRepartidor = int.parse(data);
    notifyListeners();
  }

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

  set setiscodelectorQR(data) {
    this.islectorQR = data;
    notifyListeners();
  }

  set setPreciogarrafon(data) {
    this.preciogarrafon = data;
    notifyListeners();
  }

  set setPay(data) {
    this.pay = data;
    notifyListeners();
  }

  /// GETTERS OF REPARTIDORES  */

  int get getid => this.idRepartidor;
  String get getnombre => this.nombre;
  String get getavatar => this.avatar;
  String get getgarrafonesvendidos => this.garrafonesVendidos;
  String get getpuntos => this.puntos;
  bool get getisLogin => this.isLogin;
  bool get geThemeLigth => this.themeLight;
  bool get getislectorQR => this.islectorQR;
  double get getpreciogarrafon => this.preciogarrafon;
  double get getPay => this.pay;
}
