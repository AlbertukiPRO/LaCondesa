import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Register.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Formulario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool closedialog = true;
  closeAlertDialog() {
    setState(() => closedialog = !closedialog);
  }

  /*@override
  void initState() {
    super.initState();
    showMyDialog(
      "Bienvenido a purificadora la condesa",
      context,
      "Al ser miembro de purificadora la condesa tendrás beneficios asombrosos, pero primero deberás registrarte",
      1,
    );
  }*/

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
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    color: textcolorsubtitle,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                  ),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
