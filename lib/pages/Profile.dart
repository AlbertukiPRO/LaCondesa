import 'package:flutter/material.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:lacondesa/variables/styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Orientation ori = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Header(),
            Positioned(
              top: size.height * 0.19,
              child: Hero(
                tag: 'fotoprofile',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 8,
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: size.aspectRatio * 150,
                    backgroundImage:
                        NetworkImage(context.watch<User>().getavatar),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              child: Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                child: Text(
                  '' + context.watch<User>().getnombre,
                  style: textsubtitle,
                  textScaleFactor: 1.8,
                  softWrap: true,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.45,
              child: Container(
                width: size.width * 0.8,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadisticas ',
                      style: texttitle2,
                      textScaleFactor: 1.4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ItemProfile(
                        nameitem: "Comenza a trabajar en La condesa: ",
                        icon: Icon(
                          LineIcons.wpexplorer,
                          color: secundarycolor,
                          size: 25,
                        ),
                        data: "15 de Marzo del 2021"),
                    ItemProfile(
                        nameitem: "Numero de garrafones vendidos",
                        icon: Icon(
                          LineIcons.water,
                          color: secundarycolor,
                          size: 25,
                        ),
                        data: "x 15"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemProfile extends StatelessWidget {
  final String nameitem;
  final Icon icon;
  final String data;

  ItemProfile({
    Key key,
    this.nameitem,
    this.icon,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nameitem,
                  style: texttitle2,
                  textScaleFactor: 1.2,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data,
                  style: textsubtitle,
                  textScaleFactor: 1.1,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),
          icon,
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User provider = context.watch<User>();
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/img/cubrebocas.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
