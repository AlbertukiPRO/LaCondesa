import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/pages/Login.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<bool> initial() async {
    try {
      SharedPreferences disk = await SharedPreferences.getInstance();
      bool islogin = disk.getBool('isloginkey');

      if (islogin != null) {
        print('Metodo: <main()> : esta logeado => ' + islogin.toString());
        print('Metodo: <main()> : nombre => ' + disk.getString('nombrekey'));
        print('Metodo: <main()> : img => ' + disk.getString('avatarkey'));
        return true;
      } else {
        print("Close sesion");
        return false;
      }
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(),
        ),
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
          fontFamily: 'SFRegular',
        ),
        home: FutureBuilder<bool>(
          future: initial(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? snapshot.data == false
                    ? const Login()
                    : const Home()
                : Center(
                    child: const CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
