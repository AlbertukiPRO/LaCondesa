import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderPromos.dart';
import 'package:lacondesa/variables/styles.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({Key key}) : super(key: key);

  @override
  _CatalogoState createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            color: primarycolor,
            width: size.width * 0.90,
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
              alignment: Alignment.topCenter,
              width: size.width,
              margin: EdgeInsets.only(left: 10),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'NUEVAS OFERTAS',
                    style: Semibol_negra,
                    textScaleFactor: 1.3,
                  ),
                  const GetPromos()
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.7,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              decoration: BoxDecoration(
                color: primarycolor,
                borderRadius: BorderRadius.circular(15),
              ),
              width: size.width * 0.95,
              height: size.height * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tiempo restante',
                        style: TextStyle(
                            fontFamily: 'SFLigera', color: Colors.white),
                        textScaleFactor: 0.9,
                      ),
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          'Ofertas por inauguracion',
                          style: TextStyle(
                              fontFamily: 'SFBold',
                              color: Colors.white,
                              height: 1),
                          textScaleFactor: 1.6,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          'lorem impus sacalorem impus sacalorem impus sacalorem impus sacalorem impus saca',
                          style: TextStyle(
                              fontFamily: 'SFLigera', color: Colors.white),
                          textScaleFactor: 0.9,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                        ),
                        child: Text(
                          '3',
                          style: TextStyle(
                              fontFamily: 'SFRegular', color: Colors.white),
                          textScaleFactor: 3,
                        ),
                      ),
                      Text(
                        'dias restantes',
                        style: TextStyle(
                            fontFamily: 'SFRegular',
                            color: Colors.grey.shade300),
                        textScaleFactor: 0.7,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
