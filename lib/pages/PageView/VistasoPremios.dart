import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderPremios.dart';
import 'package:lacondesa/variables/styles.dart';

class VistasoClientes extends StatefulWidget {
  const VistasoClientes({Key key}) : super(key: key);

  @override
  _VistasoClientesState createState() => _VistasoClientesState();
}

class _VistasoClientesState extends State<VistasoClientes>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          color: primarycolor,
          width: size.width * 1,
          child: Container(
            decoration: BoxDecoration(
              color: primarycolor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              width: size.width * 0.80,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/img/banner_promo.png",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          alignment: Alignment.topCenter,
          width: size.width,
          margin: EdgeInsets.only(right: 10),
          height: size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                'PREMIOS',
                style: Semibol_negra,
                textScaleFactor: 1.3,
              ),
              SingleChildScrollView(
                child: const ShowPremios(
                  idcliente: "99",
                  puntos: "9999",
                  scrollIs: "v",
                ),
              ),
              /*Container(
                width: size.width,
                child: Text(
                  'Gánate estos premios comprando garrafones con la condesa, cada garrafón equivale a un punto, los puntos son acumulables y tienes vigencia',
                  style: TextStyle(
                      fontFamily: 'SFSemibold', color: Colors.white, height: 1),
                  textScaleFactor: 1.2,
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
