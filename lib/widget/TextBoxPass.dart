import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:line_icons/line_icons.dart';

class TextboxPassw extends StatefulWidget {
  const TextboxPassw({
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
  _TextboxPasswState createState() => _TextboxPasswState();
}

class _TextboxPasswState extends State<TextboxPassw> {
  bool showpasw = false;

  void enableshowpas() {
    setState(() => showpasw = !showpasw);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: TextDirection.ltr,
      autocorrect: true,
      controller: widget.nombreInput,
      obscureText: showpasw ? false : true,
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
        prefixIcon: widget.prefixicono,
        suffixIcon: InkWell(
          onTap: enableshowpas,
          borderRadius: BorderRadius.circular(25),
          child: showpasw
              ? Icon(
                  LineIcons.eye,
                  color: secundarycolor,
                )
              : Icon(
                  LineIcons.eyeSlash,
                  color: textcolorsubtitle,
                ),
        ),
        labelText: widget.textlabel,
        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
      ),
      style: TextStyle(
        fontFamily: "SFSemibold",
        color: terciarycolor,
      ),
      // ignore: missing_return
      validator: (String valor) {
        if (valor.isEmpty || valor.length > 30) {
          return widget.errorlabel;
        }
        if (valor.length <= 3) {
          return widget.errorlabel;
        }
      },
    );
  }
}
