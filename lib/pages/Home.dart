import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';

class Home extends StatefulWidget {
  @required
  final String nombre;
  @required
  final String avatar;
  Home({Key key, this.nombre, this.avatar}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();

  var _bottomNavIndex = 0;
  AnimationController _animationController;

  Animation<double> animation;

  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  final iconlist = [
    LineIcons.home,
    LineIcons.cog,
    LineIcons.file,
    LineIcons.bell,
  ];

  final pestanas = [
    'Menú',
    'Configuració',
    'Guia',
    'Alertas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        onPressed: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconlist.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? contraste : textcolorsubtitle;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 3
                  ? Badge(
                      badgeContent: Text(
                        '2',
                        style: TextStyle(color: Colors.white),
                      ),
                      badgeColor: contraste,
                      child: Icon(
                        iconlist[index],
                        size: 24,
                        color: color,
                      ),
                    )
                  : (index == 2)
                      ? Badge(
                          badgeContent: Text(
                            '5',
                            style: TextStyle(color: Colors.white),
                          ),
                          badgeColor: contraste,
                          child: Icon(
                            iconlist[index],
                            size: 24,
                            color: color,
                          ),
                        )
                      : Icon(
                          iconlist[index],
                          size: 24,
                          color: color,
                        ),
              index == _bottomNavIndex
                  ? SizedBox(height: 4)
                  : SizedBox(height: 0),
              index == _bottomNavIndex
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AutoSizeText(
                        "" + pestanas[index],
                        maxLines: 1,
                        style: TextStyle(color: color),
                        group: autoSizeGroup,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(0),
                    )
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 5,
        rightCornerRadius: 5,
        splashColor: terciarycolor,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const NavBar(
              backbutton: false,
            ),
            Positioned(
              top: 70,
              child: BarRepartidor(
                nombre: widget.nombre,
                avatar: widget.avatar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarRepartidor extends StatelessWidget {
  const BarRepartidor({
    Key key,
    @required this.nombre,
    @required this.avatar,
  }) : super(key: key);

  final String nombre;
  final String avatar;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.22,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  this.nombre,
                  style: textsubtitle,
                  textScaleFactor: 1.1,
                ),
                Text(
                  'Repartidor',
                  style: textsubtitlemini,
                ),
                Spacer(),
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(avatar),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
