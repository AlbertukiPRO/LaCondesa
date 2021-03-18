import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/TextBox.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ButtonForm.dart';
import 'package:provider/provider.dart';

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
    SharedPreferences disk = await SharedPreferences.getInstance();
    await http.post(
        Uri.parse("http://192.168.0.4/lacondesa/php/obtener_repartidor.php"),
        body: {
          "nombre": nombreInput.text,
          "clave": claveinput.text,
        }).then((resulta) async {
      if (resulta.statusCode == 200) {
        if (resulta.body == "nothing") {
          setState(() => status = "No se encuentra el usuario");
        } else {
          setState(() => status = "Redirigidiendo...");

          /** Decodificando el json repuesta */
          final body = json.decode(resulta.body);
          final String rutaimg =
              "http://192.168.0.4/lacondesa/php/ReProfilesimgs/";

          /** Almacenando datos de sesión en la clase User con ChangeNotifier */
          context.read<User>().setnombre = body[0]['nombreRepartidor'];
          context.read<User>().setavatar = rutaimg + body[0]['img_profile'];
          context.read<User>().setisLogin = true;
          context.read<User>().setpuntos = "0";
          context.read<User>().setid = int.parse(body[0]['idRepartidores']);

          //guardamos el estado de inicio de sesion en el disco.
          await disk.setString('nombrekey', body[0]['nombreRepartidor']);
          await disk.setString('avatarkey', rutaimg + body[0]['img_profile']);
          await disk.setBool('isloginkey', true);
          await disk.setString('idkey', body[0]['idRepartidores']);
          await disk.setString('puntoskey', '0');
          //
          //context.read<User>().initial();
          Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            ),
          );
          print("Metodo <startLogin()> : API => " +
              body[0]['idRepartidores'] +
              body[0]['nombreRepartidor']);
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
            errorlabel: "Por favor ingresé un nombre válido",
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
