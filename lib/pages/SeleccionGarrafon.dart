import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lacondesa/pages/Premios.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/pages/Inicio.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
  int countgarrafones = 1;
  double preciogarrafon = 0;
  double preciototal = 0;
  bool estatus = false;
  String mensanje = "";
  double _currentSlider = 1;

  final riveFileName = 'assets/img/newagua.riv';
  Artboard _artboard;

  @override
  void initState() {
    this.preciototal = widget.preciogarrafon * countgarrafones;
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();
    if (file.import(bytes)) {
      setState(() =>
          _artboard = file.mainArtboard..addController(SimpleAnimation('add')));
    }
  }

  bool closedialog = false;
  closeAlertDialog() {
    setState(() => closedialog = !closedialog);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: estatus ? 0.0 : 1.0,
        child: InkWell(
          onTap: () => addventa(Provider.of<User>(context, listen: false).getid,
              int.parse(widget.id)),
          child:
              BotonAddCompra(size: size, estatus: estatus, mensanje: mensanje),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20),
              height: size.height * 0.35,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/img/ilustraciones-gratuitas.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              height: size.height * 0.35,
              decoration:
                  BoxDecoration(color: Color(0xFFF3B5FFE).withOpacity(0.80)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 0, right: 0, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 30),
                    child: Text(
                      'Venta de Garrafón para:',
                      style: TextStyle(
                          fontFamily: 'SFSemibold', color: Colors.white),
                      textScaleFactor: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerCliente(
                    nombre: widget.nombre,
                    puntos: widget.puntos,
                    size: size,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ContainerPuntos(
                        puntos: widget.puntos,
                        id: widget.id,
                        size: size,
                      ),
                      _artboard != null
                          ? Container(
                              padding: EdgeInsets.only(left: size.width * 0.12),
                              width: 350,
                              height: 350,
                              child: Rive(
                                alignment: Alignment.centerLeft,
                                artboard: _artboard,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Container(
                              child: SvgPicture.asset(
                                "assets/img/botella-de-agua.svg",
                                width: 250,
                                height: 250,
                              ),
                            ),
                      SizedBox(
                        height: 20,
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
                                  double.parse(
                                      _currentSlider.round().toString());
                              print(this.preciototal);
                            });
                            _loadRiveFile();
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                          width: size.width * 0.8,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Precio unitario',
                                    style: textligth,
                                    textScaleFactor: 1.2,
                                  ),
                                  Text(
                                    '\$${widget.preciogarrafon}',
                                    style: TextStyle(
                                      fontFamily: 'SFSemibold',
                                      color: textcolortitle,
                                    ),
                                    textScaleFactor: 1.3,
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'No. garrafones',
                                    style: textligth,
                                    textScaleFactor: 1.2,
                                  ),
                                  Text(
                                    'x ${this._currentSlider.round().toString()}',
                                    style: TextStyle(
                                      fontFamily: 'SFSemibold',
                                      color: textcolortitle,
                                    ),
                                    textScaleFactor: 1.3,
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Precio total',
                                    style: textligth,
                                    textScaleFactor: 1.2,
                                  ),
                                  Text(
                                    '\$${this.preciototal}',
                                    style: TextStyle(
                                      fontFamily: 'SFSemibold',
                                      color: contraste,
                                    ),
                                    textScaleFactor: 1.3,
                                  )
                                ],
                              ),
                            ],
                          )),
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
          ],
        ),
      ),
    );
  }

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

  Future<void> showMyDialog1() async => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text(
                  "Compra Realizada con exito",
                  style: Semibol_negra,
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
}

class ContainerPuntos extends StatelessWidget {
  const ContainerPuntos({
    Key key,
    @required this.puntos,
    @required this.id,
    @required this.size,
  }) : super(key: key);

  final String id;
  final String puntos;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return int.parse(this.puntos) >= context.watch<User>().getMinPoint
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => null,
                  child: int.parse(this.puntos) >=
                          context.watch<User>().getMinPoint
                      ? Text(
                          'Premios disponibles: 1',
                          style: Regular_negra,
                        )
                      : Text(
                          'Premios disponibles: 0',
                          style: Semibol_negra,
                        ),
                ),
                Container(
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
                              puntos: this.puntos,
                              idcliente: this.id,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 1,
          );
  }
}

class ContainerCliente extends StatelessWidget {
  const ContainerCliente({
    Key key,
    @required this.nombre,
    @required this.size,
    @required this.puntos,
  }) : super(key: key);

  final String nombre;
  final String puntos;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: contraste,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                this.nombre,
                style: TextStyle(color: Colors.white70, fontFamily: 'SFBold'),
                textScaleFactor: 1.5,
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/img/bleach.svg",
                    width: 12,
                    height: 12,
                    color: Colors.deepOrangeAccent,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrangeAccent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                              this.puntos == "null" ? '0' : this.puntos,
                              style: TextStyle(
                                  fontFamily: 'SFBold',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              textScaleFactor: 2,
                            )
                          ],
                        ),
                        Container(
                          width: size.width,
                          child: Text(
                            'Puntos',
                            style: TextStyle(
                                fontFamily: 'SFRegular',
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BotonAddCompra extends StatelessWidget {
  const BotonAddCompra({
    Key key,
    @required this.size,
    @required this.estatus,
    @required this.mensanje,
  }) : super(key: key);

  final Size size;
  final bool estatus;
  final String mensanje;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      constraints: BoxConstraints(
        maxHeight: size.height * 0.12,
        minHeight: size.height * 0.08,
      ),
      height: 65,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: contraste, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            estatus ? mensanje : 'Confirmar compra',
            style: texttitle,
            textScaleFactor: 1.3,
          ),
          SizedBox(
            width: 10,
          ),
          SvgPicture.asset(
            "assets/icons/cartera.svg",
            width: 25,
            height: 25,
          ),
        ],
      ),
    );
  }
}
