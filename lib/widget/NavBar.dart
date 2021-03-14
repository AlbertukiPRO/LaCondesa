import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:line_icons/line_icon.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    Key key,
    @required this.backbutton,
  }) : super(key: key);

  final bool backbutton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(gradient: primarycolorGradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backbutton
                ? InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
            Text(
              'Purificadora la Condesa',
              style: texttitle,
              textAlign: TextAlign.center,
              textScaleFactor: 1,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.security_outlined,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              onTap: () => null,
            ),
          ],
        ),
      ),
    );
  }
}
