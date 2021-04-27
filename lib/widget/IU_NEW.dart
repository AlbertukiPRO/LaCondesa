import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/pages/NewQR_Lector.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/Balance.dart';
import 'package:lacondesa/widget/Catalogo.dart';
import 'package:lacondesa/widget/Historial.dart';
import 'package:lacondesa/widget/Venta_newvercion.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
    Provider.of<User>(context, listen: false).getid == null
        ? buildProvier(context)
        : print('');
  }

  buildProvier(BuildContext context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    context.read<User>().setnombre = disk.getString('nombrekey');
    context.read<User>().setavatar = disk.getString('avatarkey');
    context.read<User>().setisLogin = true;
    context.read<User>().setid = disk.getString('idkey');
    context.read<User>().setCostoRecarga = disk.getDouble("keyrecarga");
    context.read<User>().setMinpoint = disk.getInt("keyminpt");
    context.read<User>().setPreciogarrafon = disk.getDouble("keypreciogarr");
    print("Logeado como = " +
        disk.getString('nombrekey') +
        disk.getString('avatarkey'));
  }

  int _selectedIndex = 0;

  get selectedIndex => this._selectedIndex;

  set selectedIndex(int _selectedIndex) {
    this._selectedIndex = _selectedIndex;
  }

  final iconlist = <IconData>[
    LineIcons.home,
    LineIcons.tint,
    Icons.card_giftcard,
    LineIcons.cog,
  ];

  final pestanas = [
    'Menú',
    'Garrafones',
    'Premios',
    'Configuración',
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              MaterialPageRoute(builder: (context) => QRNEW()),
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
            changePage(index);
          },
        ),
      ),
      body: PageView(
        onPageChanged: (vale) {
          setState(() {
            _bottomNavIndex = vale;
          });
        },
        controller: _pageController,
        children: [
          Balance(),
          Catalogo(),
          Historial(),
          Historial(),
        ],
      ),
    );
  }

  void changePage(int value) {
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}
