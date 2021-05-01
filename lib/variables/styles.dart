import 'package:alert/alert.dart';
import 'package:flutter/material.dart';

/* Estilos para los parrafos textos y titulos */
const textligth = TextStyle(fontFamily: 'SFLigera', color: primarycolor);

const titleapp = "Purificadora la Condesa";

const texttitle = TextStyle(
  fontFamily: 'SFSemibold',
  color: Colors.white,
);

const textsubtitle = TextStyle(fontFamily: 'SFBlack', color: textcolorsubtitle);
const textsubtitlemini =
    TextStyle(fontFamily: 'SFSemibold', color: textcolorsubtitle);

const texttitle2 = TextStyle(fontFamily: 'SFSemibold', color: textcolortitle);

const subtext = TextStyle(fontFamily: 'SFRegular', color: textcolortitle);

const dinerofont = TextStyle(fontFamily: 'SFBlack', color: contraste);

const gradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.1, 0.4, 0.7],
  colors: [
    Color(0xFF8BC6EC),
    terciarycolor,
    Color(0xFF9599E2),
  ],
);

const mask = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment(0.0, 0.0), // 10% of the width, so there are ten blinds.
  colors: [
    const Color.fromRGBO(0, 0, 0, 0.7),
    const Color.fromRGBO(0, 0, 0, 0.9),
  ],
);

/* Paleta de colores para La condesa*/

const primarycolor = Color(0xFF4461D0);
const secundarycolor = Color(0xFF4A7DE4);
const terciarycolor = Color(0xFF519AF9);
const contraste = Color(0xFF2ecc71);
const textcolortitle = Color(0xFF2d3436);
const textcolorsubtitle = Color(0xFF636e72);
const textcolorregular = Color.fromARGB(1, 47, 54, 64);

const primarycolorGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    primarycolor,
    secundarycolor,
    terciarycolor,
  ],
);

void toast(sms) => Alert(message: sms).show();

// Type Dialog (1) => Normal
// Type Dialog (2) => Warning
// Type Dialog (3) => Error
// Type Dialog (4) => Info
// ignore: unused_element
Future<void> showMyDialog(String title, BuildContext context, String cuerpo,
        int typeDialog) async =>
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  cuerpo,
                  textAlign: TextAlign.justify,
                ),
                typeDialog == 1
                    ? Icon(
                        Icons.message,
                        size: 25,
                        color: primarycolor,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                typeDialog == 2
                    ? Icon(
                        Icons.warning_outlined,
                        size: 25,
                        color: Colors.yellowAccent,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                typeDialog == 3
                    ? Icon(
                        Icons.error,
                        size: 45,
                        color: Colors.redAccent,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                typeDialog == 4
                    ? Icon(
                        Icons.info_outline_rounded,
                        size: 25,
                        color: Colors.greenAccent,
                      )
                    : SizedBox(
                        height: 1,
                      ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            )
          ],
        );
      },
    );
