import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:lacondesa/main.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/widget/Bar.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NavBar(
          backbutton: false,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 70,
            ),
            BarRepartidor(
              nombre: "Configuraciones",
              avatar: context.watch<User>().getavatar,
            ),
            const Lista(),
          ],
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class Lista extends StatefulWidget {
  const Lista({
    Key key,
  }) : super(key: key);

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final AsyncMemoizer<bool> _memoizer = AsyncMemoizer();
  bool estatus = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      height: size.height * 0.5,
      width: size.width,
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.wifi_lock),
            title: Text('Ahorro de datos [No disponible]'),
            onTap: () {
              print('get location');
            },
          ),
          ListTile(
            leading: estatus == false
                ? Icon(Icons.update_outlined)
                : Icon(Icons.system_update_tv),
            title: Text('Actulizar precios'),
            onTap: () {
              setState(() => estatus = true);
              getConfiguraciones(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard_customize),
            title: Text('Terminos y Condiciones'),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_sharp),
            title: Text('Lector QR - Pruebas'),
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Cerrar Sesion'),
            onTap: () {
              context.read<User>().setisLogin = null;
              closesecion();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ],
      ),
    );
  }

  Future<bool> getConfiguraciones(context) async {
    return this._memoizer.runOnce(() async {
      try {
        SharedPreferences disk = await SharedPreferences.getInstance();
        http.Response response = await http.get(Uri.parse(
            "https://enfastmx.com/lacondesa/get_configuraciones.php"));
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          print(result);

          Provider.of<User>(context, listen: false).setPreciogarrafon =
              double.parse(result[0]['preciogr'].toString());
          Provider.of<User>(context, listen: false).setMinpoint =
              int.parse(result[0]['minpt'].toString());
          Provider.of<User>(context, listen: false).setCostoRecarga =
              double.parse(result[0]['recarga'].toString());

          await disk.setDouble(
              'keypreciogarr', double.parse(result[0]['preciogr'].toString()));
          await disk.setInt(
              'keyminpt', int.parse(result[0]['minpt'].toString()));
          await disk.setDouble(
              'keyrecarga', double.parse(result[0]['recarga'].toString()));

          setState(() {
            estatus = !estatus;
          });
        } else {
          setState(() {
            estatus = !estatus;
          });
        }
      } catch (e) {
        print(e);
      }
      return true;
    });
  }

  closesecion() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    await disk.remove('isloginkey');
    await disk.remove('nombrekey');
    await disk.remove('avatarkey');
    await disk.remove('idkey');
    await disk.remove('puntoskey');
    await disk.remove('keypreciogarr');
    await disk.remove('keyminpt');
    await disk.remove('keyrecarga');
  }
}

class Perfil extends StatelessWidget {
  const Perfil({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User provider = context.watch<User>();
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: size.aspectRatio * 80,
          backgroundImage: NetworkImage(provider.getavatar),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                provider.getnombre,
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(0),
              child: Text(
                '#se queda en casa',
              ),
            ),
          ],
        )
      ],
    );
  }
}
