import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';

class ButtonForm extends StatelessWidget {
  const ButtonForm({
    Key? key,
    @required this.txtbutton,
    @required this.colorbtn,
  }) : super(key: key);

  final String? txtbutton;
  final Color? colorbtn;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          color: contraste,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            txtbutton!,
            style: TextStyle(fontFamily: 'SFSemibold', color: Colors.white),
            textScaleFactor: 1.1,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
