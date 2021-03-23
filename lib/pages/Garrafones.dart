import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderPromos.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Bar.dart';
import 'package:lacondesa/widget/NavBar.dart';

class Garrafones extends StatelessWidget {
  const Garrafones();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const NavBar(
          backbutton: false,
        ),
        Column(
          children: [
            SizedBox(
              height: 70,
            ),
            BarRepartidor(
                nombre: "Garrafones",
                avatar:
                    "https://aquaclyva.mx/wp-content/uploads/2018/03/garrafon-19l-1.jpg"),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width * 0.8,
              child: Text(
                'Promociones',
                style: texttitle2,
                textScaleFactor: 1.1,
              ),
            ),
            Container(child: const GetPromos()),
          ],
        ),
      ],
    );
  }
}
