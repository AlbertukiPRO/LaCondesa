import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/pages/Settings.dart';
import 'package:lacondesa/pages/Ventas.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Garrafones.dart';
import 'HomeWidget.dart';
import 'QR_Lector.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

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
    buildProvier(context);
  }

  int _selectedIndex = 0;

  get selectedIndex => this._selectedIndex;

  set selectedIndex(int _selectedIndex) {
    this._selectedIndex = _selectedIndex;
  }

  final iconlist = <IconData>[
    LineIcons.home,
    LineIcons.tint,
    LineIcons.store,
    LineIcons.cog,
  ];

  final pestanas = [
    'Menú',
    'Garrafones',
    'Ventas',
    'Configuración',
  ];

  List<Widget> tabs = <Widget>[
    const HomeWidget(),
    const Garrafones(),
    const Ventas(),
    const Settings(),
  ];

  buildProvier(BuildContext context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    context.read<User>().setnombre = disk.getString('nombrekey');
    context.read<User>().setavatar = disk.getString('avatarkey');
    context.read<User>().setisLogin = true;
    context.read<User>().setid = disk.getString('idkey');
    print("Logeado como = " +
        disk.getString('nombrekey') +
        disk.getString('avatarkey'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 8,
          child: Icon(Icons.qr_code_scanner),
          onPressed: () {
            _animationController.reset();
            _animationController.forward();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRLector(),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconlist.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? primarycolor : Colors.blueGrey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconlist[index],
                size: 24,
                color: color,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AutoSizeText(
                  "" + pestanas[index],
                  maxLines: 1,
                  style: TextStyle(color: color),
                  group: autoSizeGroup,
                ),
              ),
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
        onTap: (index) => setState(
          () {
            _bottomNavIndex = index;
            _selectedIndex = index;
          },
        ),
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
              child: SingleChildScrollView(child: tabs[_selectedIndex]),
            ),
          ],
        ),
      ),
    );
  }
}
