import 'package:flutter/material.dart';

/* Estilos para los parrafos textos y titulos */
const textligth = TextStyle(
  fontFamily: 'SFLigera',
);

const titleapp = "Purificadora la Condesa";

const texttitle = TextStyle(
  fontFamily: 'SFSemibold',
  color: Colors.white,
);

const textsubtitle = TextStyle(fontFamily: 'SFBlack', color: textcolorsubtitle);
const textsubtitlemini =
    TextStyle(fontFamily: 'SFSemibold', color: textcolorsubtitle);

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
