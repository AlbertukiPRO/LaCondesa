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
  String status;

  TextEditingController nombreInput = new TextEditingController();
  TextEditingController claveinput = new TextEditingController();

  void showpassword() {
    setState(() => showtextpassword = !showtextpassword);
  }

  Future<void> startLogin(BuildContext context) async {
    await http.post(
        Uri.parse("http://192.168.0.4/lacondesa/php/obtener_repartidor.php"),
        body: {
          "nombre": nombreInput.text,
          "clave": claveinput.text,
        }).then((resulta) {
      if (resulta.statusCode == 200) {
        if (resulta.body == "nothing") {
          setState(() => status = "No se encuentra el usuario");
        } else {
          setState(() => status = "Redirigidiendo...");
          final body = json.decode(resulta.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                nombre: body[0]['nombreRepartidor'],
                avatar: "http://192.168.0.4/lacondesa/php/ReProfilesimgs/" +
                    body[0]['img_profile'],
              ),
            ),
          );
          print(body[0]['nombreRepartidor']);
        }
      } else {
        setState(() => status = "No fue posible conectar con el servidor.");
      }
    });
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
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // devolverá true si el formulario es válido, o falso si
              // el formulario no es válido.
              if (_formkey.currentState.validate()) {
                // Si el formulario es válido, queremos mostrar un Snackbar
                //peticionServer();
                if (_formkey.currentState.validate()) {
                  startLogin(context).whenComplete(() {
                    final snackBar = SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status == null ? "Cargando..." : status,
                            style: TextStyle(color: Colors.white),
                          ),
                          status == null
                              ? CircularProgressIndicator()
                              : Icon(
                                  LineIcons.server,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: primarycolor,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
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
