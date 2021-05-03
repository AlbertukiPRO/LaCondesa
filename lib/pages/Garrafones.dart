import 'package:flutter/material.dart';
import 'package:lacondesa/variables/BuilderPromos.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:provider/provider.dart';
import 'package:lacondesa/variables/styles.dart';
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
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              width: size.width,
              child: TextButton(
                onPressed: () => null,
                child: Text('Precio actual de la recarga: \$' +
                    context.watch<User>().getcostoRecarga.toString()),
              ),
            ),
            Container(
              width: size.width * 0.8,
              child: Text(
                'Promociones',
                style: Semibol_negra,
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
