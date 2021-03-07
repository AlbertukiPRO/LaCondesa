import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Login.dart';
import 'package:lacondesa/variables/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const Login(),
    );
  }
}
