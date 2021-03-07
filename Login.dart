import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Register.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Formulario.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool closedialog = true;
  closeAlertDialog() {
    setState(() => closedialog = !closedialog);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          scale: 1,
                          image: AssetImage(
                            'assets/img/banner.png',
                          ),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inicio de Sesión',
                            style: TextStyle(
                              fontFamily: 'SFSemibold',
                              color: textcolortitle,
                            ),
                            textScaleFactor: 1.6,
                          ),
                          Text(
                            'Repartidores',
                            style: TextStyle(
                              fontFamily: 'SFRegular',
                              color: textcolorsubtitle,
                            ),
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 35),
                      child: const Formulario(),
                    ),
                    SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => null,
                          child: Text(
                            'Ver terminos y condiciones',
                            style: TextStyle(
                              color: textcolorsubtitle,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          ),
                          child: Text(
                            'Registrarce',
                            style: TextStyle(
                              color: textcolorsubtitle,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              closedialog
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.0,
                              0.0), // 10% of the width, so there are ten blinds.
                          colors: [
                            const Color.fromRGBO(0, 0, 0, 0.7),
                            const Color.fromRGBO(0, 0, 0, 0.9),
                          ],
                        ),
                      ),
                      child: AlertDialog(
                        title: Text('Bienvenido a purificadora la condesa'),
                        content: Text(
                          'Al ser miembro de purificadora la condesa tendras beneficios asombrosos pero primero deberas registrarte',
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => closeAlertDialog(),
                            child: Text('Aceptar'),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
