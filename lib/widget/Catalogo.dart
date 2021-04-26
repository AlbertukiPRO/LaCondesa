import 'package:flutter/material.dart';

class Catalogo extends StatefulWidget {
  Catalogo({Key key}) : super(key: key);

  @override
  _CatalogoState createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Catalogo'),
    );
  }
}
