import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';

class VentaScreen extends StatefulWidget {
  final bool estado;
  VentaScreen({Key key, this.estado}) : super(key: key);

  @override
  _VentaScreenState createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: widget.estado
            ? Text(
                'Gracias por comprar',
                style: textsubtitlemini,
              )
            : Text(
                'No se pudo completar su compra',
                style: textsubtitlemini,
              ),
      ),
    );
  }
}
