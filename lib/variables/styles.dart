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
