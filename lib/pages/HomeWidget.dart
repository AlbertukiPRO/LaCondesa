import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Bar.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/widget/NavBar.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final riveFileName = 'assets/icons/coins.riv';
  Artboard _artboard;
  bool conectionapi = false;
  Future mydata;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('coinsmove'),
        ));
    }
  }

  Future getDataPoints(String id) async {
    try {
      http.Response response = await http.post(
          Uri.parse("https://enfastmx.com/lacondesa/getsaldoandpoints.php"),
          body: {
            "idrepartidor": id,
          });
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);

        //context.read<User>().setpuntos =
        //context.read<User>().setPay =

        return result;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
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
              nombre: context.watch<User>().getnombre,
              avatar: context.watch<User>().getavatar == null
                  ? "https://www.w3schools.com/howto/img_avatar2.png"
                  : context.watch<User>().getavatar,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Text(
                'Puntos totales',
                style: texttitle2,
                textScaleFactor: 1.2,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _artboard != null
                      ? Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Rive(
                              artboard: _artboard,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Container(),
                ),
                FutureBuilder(
                  future: getDataPoints(
                      '' + context.watch<User>().getid.toString()),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      var mydata = snapshot.data;
                      return Center(
                        child: Text(
                          'x ${mydata[0]['Puntos']}',
                          style: texttitle2,
                          textScaleFactor: 2,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            ),
            TextButton(
              onPressed: () => null,
              child: Text('Los puntos se reiniciar diariamente'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Text(
                'Mi cuenta',
                style: texttitle2,
                textScaleFactor: 1.2,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/calculator.svg",
                  width: 100,
                  height: 100,
                ),
                FutureBuilder(
                  future: getDataPoints(
                      '' + context.watch<User>().getid.toString()),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      var mydata = snapshot.data;
                      return Center(
                          child: Text(
                        '\$ ${mydata[0]['Ganancias']}',
                        style: texttitle2,
                        textScaleFactor: 2,
                      ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () => null,
              child: Text('Estado de cuenta del dia de hoy'),
            )
          ],
        ),
      ],
    );
  }
}
