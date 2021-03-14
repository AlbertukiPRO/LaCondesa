import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/TextBox.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'ButtonForm.dart';

class Formulario extends StatefulWidget {
  const Formulario({
    Key key,
  }) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formkey = GlobalKey<FormState>();
  bool showtextpassword = false;
  bool loginstatus = false;
  String status = "";

  TextEditingController nombreInput = new TextEditingController();
  TextEditingController claveinput = new TextEditingController();

  void showpassword() {
    setState(() => showtextpassword = !showtextpassword);
  }

  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enviando datos al servidor espera...',
          style: TextStyle(color: Colors.white),
        ),
        CircularProgressIndicator(),
      ],
    ),
    duration: Duration(seconds: 20),
    backgroundColor: primarycolor,
  );

  sendData(String user, String clave) {
    bool cheked = false;
    if (user == "Alberto Noche Rosas" && clave == "@#123") {
      cheked = !cheked;
    }
    return cheked;
  }

  startLogin(BuildContext context) {
    http.post(Uri.parse(""), body: {
      "nombre": nombreInput.text,
      "clave": claveinput.text,
    }).then((resulta) {
      if (resulta.statusCode == 200) {
        if (resulta.body == "nothing") {
          setState(() => status = "No se encuatra el usuario");
        } else {
          final body = json.decode(resulta.body);
        }
      } else {
        setState(() => status = "No fue posible conectar con el servidor.");
      }
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          nombre: nombreInput.text,
          clave: claveinput.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          textbox(
            nombreInput: nombreInput,
            textlabel: "Nombre de Usuario",
            errorlabel: "Por favor ingrese un nombre valido",
            prefixicono: Icon(
              LineIcons.userAlt,
              color: secundarycolor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            obscureText: showtextpassword ? false : true,
            textDirection: TextDirection.ltr,
            autocorrect: false,
            enableSuggestions: false,
            controller: claveinput,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
                borderSide: BorderSide(color: secundarycolor, width: 2),
              ),
              focusColor: contraste,
              hoverColor: contraste,
              fillColor: terciarycolor,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
                borderSide: new BorderSide(color: contraste),
              ),
              counterStyle: TextStyle(
                fontSize: 20,
                fontFamily: "SFSemibold",
                color: terciarycolor,
              ),
              prefixIcon: Icon(
                LineIcons.key,
                color: secundarycolor,
              ),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => showpassword(),
                child: showtextpassword
                    ? Icon(
                        LineIcons.eye,
                      )
                    : Icon(
                        LineIcons.eyeSlashAlt,
                        color: secundarycolor,
                      ),
              ),
              labelText: 'Clave',
              contentPadding: EdgeInsets.only(top: 20, bottom: 20),
            ),
            style: TextStyle(
              fontFamily: "SFSemibold",
              color: terciarycolor,
            ),
            // ignore: missing_return
            validator: (String valor) {
              if (valor.isEmpty) {
                return 'Por favor ingrese un clave valida';
              }
            },
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              // devolverá true si el formulario es válido, o falso si
              // el formulario no es válido.
              if (_formkey.currentState.validate()) {
                // Si el formulario es válido, queremos mostrar un Snackbar
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //peticionServer();
                if (_formkey.currentState.validate()) {
                  startLogin(context);
                } else {}
              }
            },
            child: ButtonForm(
              txtbutton: 'Inciar Sesión',
              colorbtn: contraste,
            ),
          ),
        ],
      ),
    );
  }
}
