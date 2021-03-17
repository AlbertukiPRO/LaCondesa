import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';

class Ventas extends StatefulWidget {
  const Ventas();

  @override
  _VentasState createState() => _VentasState();
}

class _VentasState extends State<Ventas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'ventas',
        style: texttitle2,
      ),
    );
  }
}
