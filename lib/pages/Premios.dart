import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderPremios.dart';
import 'package:lacondesa/variables/styles.dart';

class Premios extends StatefulWidget {
  final String idcliente;
  final String puntos;
  Premios({Key key, this.puntos, this.idcliente}) : super(key: key);

  @override
  _PremiosState createState() => _PremiosState();
}

class _PremiosState extends State<Premios> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/icons/confeti.gif",
                    ),
                    fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: size.width * 0.6,
                child: Text(
                  'Felizades se ha ganado un premio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'SFBlack', color: Color(0xFF6F1E51)),
                  textScaleFactor: 2,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Seleccione su premio:',
                    style: texttitle2,
                    textScaleFactor: 1.1,
                  )
                ],
              ),
            ),
            Container(
              child: ShowPremios(
                puntos: widget.puntos,
                idcliente: widget.idcliente,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
