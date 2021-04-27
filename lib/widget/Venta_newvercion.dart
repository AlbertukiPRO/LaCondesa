import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lacondesa/pages/Premios.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/widget/IU_NEW.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentaIUX extends StatefulWidget {
  final String nombre;
  final String id;
  final String puntos;
  final double preciogarrafon;

  VentaIUX({
    Key key,
    this.nombre,
    this.id,
    this.puntos,
    this.preciogarrafon,
  }) : super(key: key);

  @override
  _VentaIUXState createState() => _VentaIUXState();
}

class _VentaIUXState extends State<VentaIUX>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTween;

  int countgarrafones = 1;
  double preciogarrafon = 0;
  double preciototal = 0;

  final riveFileName = 'assets/img/agua.riv';
  Artboard _artboard;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _colorTween = ColorTween(
            begin: Colors.orangeAccent.shade100, end: Colors.blue.shade100)
        .animate(_animationController);
    _animationController.forward();
    this.preciototal = widget.preciogarrafon * countgarrafones;
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(SimpleAnimation('bote')));
    }
  }

  bool closedialog = false;
  closeAlertDialog() {
    setState(() => closedialog = !closedialog);
  }

  bool estatus = false;
  String mensanje = "";

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  double _currentSlider = 1;

  addventa(int idR, int idC) async {
    setState(() => estatus = true);
    print("idCliente: " +
        idC.toString() +
        ", IdRepartidor: " +
        idR.toString() +
        ", N. garrafones" +
        countgarrafones.toString() +
        ", total: " +
        this.preciototal.toString());
    await http
        .post(Uri.parse("https://enfastmx.com/lacondesa/add_venta.php"), body: {
          "id_cliente": '' + idC.toString(),
          "id_repartidor": '' + idR.toString(),
          "garrafones": '' + countgarrafones.toString(),
          "total": '' + this.preciototal.toString(),
        })
        .then((response) {
          if (response.body == "nothing") {
            setState(() {
              mensanje = "No se pudo realizar la compra";
              estatus = true;
            });
          } else if (response.body == "ok") {
            setState(() {
              mensanje = "Compra realizada";
              estatus = true;
            });
            showMyDialog1();
          }
        })
        .timeout(Duration(seconds: 40))
        .catchError((onError) {
          setState(() {
            mensanje = "Error Conection";
            estatus = true;
          });
          showMyDialog1();
        });
  }

  Future getPrecios() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    setState(() {
      this.preciogarrafon = disk.getDouble('keypreciogarr');
    });
  }

  Future<void> showMyDialog1() async => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text(
                  "Compra Realizada con exito",
                  style: texttitle2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/icons/success.gif",
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    "Gracias por su compra. \nUsted a sumado un punto a su cuenta. En total tiene:\n",
                  ),
                  TextButton(
                    onPressed: () => null,
                    child: Text(
                      '' +
                          (int.parse(widget.puntos) + countgarrafones)
                              .toString(),
                      style: TextStyle(color: contraste),
                      textScaleFactor: 1.5,
                    ),
                  ),
                  Text('¡¡¡Gracias!!!'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  closeAlertDialog();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Inicio(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cerrar'),
                ),
              ),
            ],
          );
        },
      );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      bottomNavigationBar: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: estatus ? 0.0 : 1.0,
        child: InkWell(
          onTap: () {
            addventa(
              Provider.of<User>(context, listen: false).getid,
              int.parse(widget.id),
            );
          },
          child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              color: contraste,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  estatus ? mensanje : 'Confirmar compra',
                  style: texttitle,
                  textScaleFactor: 1.5,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Venta de Garrafón',
                        style: TextStyle(
                            fontFamily: 'SFSemibold', color: primarycolor),
                        textScaleFactor: 2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primarycolor,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.nombre,
                        style: textsubtitle,
                        textScaleFactor: 1.5,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/coins.svg",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.puntos == "null" ? '0' : widget.puntos,
                              style: texttitle2,
                              textScaleFactor: 2,
                            )
                          ],
                        ),
                        Text(
                          'Total, de puntos acumulados',
                          style: textligth,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => null,
                          child: int.parse(widget.puntos) >=
                                  context.watch<User>().getMinPoint
                              ? Text(
                                  'Premios disponibles: 1',
                                  style: textsubtitle,
                                )
                              : Text(
                                  'Premios disponibles: 0',
                                  style: texttitle2,
                                ),
                        ),
                        int.parse(widget.puntos) >=
                                context.watch<User>().getMinPoint
                            ? Container(
                                width: size.width * 0.35,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/icons/regalo.gif",
                                      fit: BoxFit.cover,
                                      width: 80,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: textcolorsubtitle,
                                        size: 25,
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Premios(
                                            puntos: widget.puntos,
                                            idcliente: widget.id,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 1,
                              ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorTween.value,
                        ),
                        child: _artboard != null
                            ? Center(
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  child: Rive(
                                    artboard: _artboard,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : Container(
                                child: SvgPicture.asset(
                                  "assets/img/botella-de-agua.svg",
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Costo total por ${this._currentSlider.round().toString()} garrafones',
                        style: texttitle2,
                        textScaleFactor: 1.1,
                      ),
                      TextButton(
                        onPressed: () => null,
                        child: Text(
                          '\$' + this.preciototal.toString(),
                          textScaleFactor: 1.5,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepOrangeAccent),
                          overlayColor: MaterialStateProperty.all(contraste),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      )
                    ],
                  ),
                  Slider(
                      value: _currentSlider,
                      min: 1,
                      max: 20,
                      divisions: 20,
                      label: _currentSlider.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSlider = value;
                          this.preciototal = widget.preciogarrafon *
                              double.parse(_currentSlider.round().toString());
                          print(this.preciototal);
                        });
                        if (_animationController.status ==
                            AnimationStatus.completed) {
                          _animationController.reverse();
                        } else {
                          _animationController.forward();
                        }
                        _loadRiveFile();
                      }),
                  estatus
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: 1,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
