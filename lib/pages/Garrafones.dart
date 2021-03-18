import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Bar.dart';

class Garrafones extends StatelessWidget {
  const Garrafones();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
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
        ],
      ),
    );
  }
}
