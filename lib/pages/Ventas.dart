import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderVentas.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Bar.dart';
import 'package:lacondesa/widget/NavBar.dart';

class Ventas extends StatefulWidget {
  const Ventas();

  @override
  _VentasState createState() => _VentasState();
}

class _VentasState extends State<Ventas> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NavBar(backbutton: false),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 70,
            ),
            BarRepartidor(
              nombre: "Ventas",
              avatar: "https://www.w3schools.com/howto/img_avatar2.png",
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              child: Text(
                '10 ultimas ventas',
                style: textsubtitlemini,
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 380,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: const GetVentas(),
            ),
          ],
        )
      ],
    );
  }
}
