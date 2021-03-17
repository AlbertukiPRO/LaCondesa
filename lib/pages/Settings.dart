import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BarRepartidor(
            nombre: "Configuraciones",
            avatar: context.watch<User>().getavatar,
          ),
          const Lista(),
        ],
      ),
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
            leading: Icon(Icons.map),
            title: Text('Obtener Ubicación'),
            onTap: () {
              print('get location');
            },
          ),
          ListTile(
              leading: Icon(Icons.security),
              title: context.watch<User>().geThemeLigth == false
                  ? Text('Tema claro activado')
                  : Text('Tema oscuro activado'),
              onTap: () {
                context.read<User>().setTheme = false;
              }),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Terminos y Condiciones'),
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Cerrar Sesion'),
            onTap: () {
              context.read<User>().setisLogin = null;
              closesecion();
            },
          ),
        ],
      ),
    );
  }

  closesecion() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    await disk.remove('isloginkey');
    await disk.remove('nombrekey');
    await disk.remove('avatarkey');
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
