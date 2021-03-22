import 'dart:convert';
import 'dart:async';
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
  String status = "";

  TextEditingController nombreInput = new TextEditingController();
  TextEditingController claveinput = new TextEditingController();

  void showpassword() {
    setState(() => showtextpassword = !showtextpassword);
  }

  Future _ackAlert(BuildContext context, String title, String cuerpo) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Icon(Icons.warning_amber_rounded, size: 25),
            ],
          ),
          content: Text(cuerpo),
          actions: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Aceptar'),
              ),
              onTap: () {
                setState(() {
                  status = "";
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static final String url =
      "https://enfastmx.com/lacondesa/obtener_repartidor.php";

  startLogin(BuildContext context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    http.post(Uri.parse(url), body: {
      "nombre": nombreInput.text,
      "clave": claveinput.text,
    }).then((resulta) async {
      if (resulta.statusCode == 200) {
        if (resulta.body == "nothing") {
          setState(() => status = "No");
          _ackAlert(context, "No se encuentra al usuario",
              "Lo centimos parece que no esta registrado en la base de datos, registrece e intentelo de nuevo.");
        } else {
          setState(() => status = "Redirigidiendo...");

          /** Decodificando el json repuesta */
          var body = json.decode(resulta.body);
          final String rutaimg =
              "https://enfastmx.com/lacondesa/ReProfilesimgs/";

          /** Almacenando datos de sesión en la clase User con ChangeNotifier */
          context.read<User>().setnombre = body[0]['nombreRepartidor'];
          context.read<User>().setavatar = rutaimg + body[0]['imgprofile'];
          context.read<User>().setisLogin = true;
          context.read<User>().setpuntos = "0";
          context.read<User>().setid = body[0]['idRepartidores'];

          //guardamos el estado de inicio de sesion en el disco.
          await disk.setString('nombrekey', body[0]['nombreRepartidor']);
          await disk.setString('avatarkey', rutaimg + body[0]['imgprofile']);
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
        setState(() => status = "No");
        _ackAlert(context, "Uppss problemas",
            "No fue posible conectar con el servidor, verifique su conexion e intentelo de nuevo");
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
          status != "" ? CircularProgressIndicator() : Text(''),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // devolverá true si el formulario es válido, o falso si
              // el formulario no es válido.
              if (_formkey.currentState.validate()) {
                startLogin(context);
                setState(() => status = "Cargando");
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
