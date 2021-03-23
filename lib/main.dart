import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/pages/Login.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AsyncMemoizer<bool> _memoizer = AsyncMemoizer();

  Future<bool> initial() async {
    bool islogin;
    return this._memoizer.runOnce(() async {
      try {
        SharedPreferences disk = await SharedPreferences.getInstance();
        islogin = disk.getBool('isloginkey');

        if (islogin != null) {
          print('Metodo: <main()> : esta logeado => ' + islogin.toString());
          print('Metodo: <main()> : nombre => ' + disk.getString('nombrekey'));
          print('Metodo: <main()> : img => ' + disk.getString('avatarkey'));
          islogin = true;
        } else {
          print("Close sesion");
          islogin = false;
        }
      } on Exception catch (exception) {
        print(exception);
      } catch (error) {
        print(error);
      }
      return islogin;
    });
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
          future: this.initial(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return snapshot.data == false ? const Login() : const Home();
              default:
                return Center(child: Text(snapshot.data.toString()));
            }
          },
        ),
      ),
    );
  }
}
