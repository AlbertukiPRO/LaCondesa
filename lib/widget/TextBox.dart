import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';

class textbox extends StatelessWidget {
  const textbox({
    Key key,
    @required this.nombreInput,
    @required this.textlabel,
    @required this.errorlabel,
    this.prefixicono,
  }) : super(key: key);

  final TextEditingController nombreInput;
  final String textlabel;
  final String errorlabel;
  final Icon prefixicono;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: TextDirection.ltr,
      autocorrect: true,
      controller: nombreInput,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: BorderSide(color: secundarycolor, width: 2),
        ),
        focusColor: contraste,
        hoverColor: primarycolor,
        fillColor: terciarycolor,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: contraste),
        ),
        counterStyle: TextStyle(
          fontSize: 20,
          color: contraste,
        ),
        prefixIcon: prefixicono,
        labelText: textlabel,
        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
      ),
      style: TextStyle(
        fontFamily: "SFSemibold",
        color: terciarycolor,
      ),
      // ignore: missing_return
      validator: (String valor) {
        if (valor.isEmpty) {
          return errorlabel;
        }
      },
    );
  }
}
