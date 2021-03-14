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
            bottomAppBarColor: Color(0xFFB2BA87),
            fontFamily: 'SFRegular',
          ),
          home: Scaffold(
            body: Cargador(),
          )),
    );
  }
}

class Cargador extends StatefulWidget {
  Cargador({Key key}) : super(key: key);

  @override
  _CargadorState createState() => _CargadorState();
}

class _CargadorState extends State<Cargador> {
  dataread(BuildContext context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    if (disk.getBool('isloginkey') != null &&
        disk.getBool('isloginkey') == true) {
      context.read<User>().initial();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    dataread(context);
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
