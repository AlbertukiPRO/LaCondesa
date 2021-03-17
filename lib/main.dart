import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/pages/Login.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: Cargador(),
    );
  }
}

class Cargador extends StatefulWidget {
  const Cargador({Key key}) : super(key: key);

  @override
  _CargadorState createState() => _CargadorState();
}

class _CargadorState extends State<Cargador> {
  datas(BuildContext context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();

    if (disk.getBool('isloginkey') != null) {
      print("ya esta logeado");
      context.read<User>().setnombre = disk.getString('nombrekey');
      context.read<User>().setavatar = disk.getString('avatarkey');
      context.read<User>().setisLogin = true;
      await disk.setBool('isloginkey', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    datas(context);
    return Center(
      child: MaterialApp(
          title: titleapp,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: primarycolor,
              accentColor: contraste,
              accentColorBrightness: Brightness.dark,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: primarycolor,
                splashColor: terciarycolor,
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              fontFamily: 'SFRegular',
              scaffoldBackgroundColor: Colors.black54),
          darkTheme: context.watch<User>().geThemeLigth
              ? ThemeData.light()
              : ThemeData.dark(),
          home: context.watch<User>().getisLogin == null
              ? const Login()
              : const Home()
          /*FutureBuilder<bool>(
            future: dataread(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.hasData
                  ? snapshot.data
                      ? const Login()
                      : const Home()
                  : CircularProgressIndicator();
            }),*/
          ),
    );
  }
}
