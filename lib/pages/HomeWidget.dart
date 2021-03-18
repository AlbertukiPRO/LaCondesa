import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Bar.dart';
import 'package:lacondesa/widget/rivetest.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BarRepartidor(
            nombre: context.watch<User>().getnombre == null
                ? ""
                : context.watch<User>().getnombre,
            avatar: context.watch<User>().getavatar == null
                ? "http://www.giar.com.mx/assets/img/team/team-man-1.png"
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
                          width: 150,
                          height: 150,
                          child: Rive(
                            artboard: _artboard,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Container(),
              ),
              Text(
                'x ' + context.watch<User>().getpuntos.toString(),
                style: texttitle2,
                textScaleFactor: 2,
              ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyRiveAnimation())),
            child: Text('¿Como gano puntos?'),
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
        ],
      ),
    );
  }
}
