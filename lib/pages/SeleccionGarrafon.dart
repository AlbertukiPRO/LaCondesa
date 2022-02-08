import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lacondesa/variables/BuilderPremios.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/pages/Inicio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class VentaIUX extends StatefulWidget {
  final String? nombre;
  final String? id;
  final String? puntos;
  final double? preciogarrafon;
  final String? typeGarrafon;

  VentaIUX({
    Key? key,
    this.nombre,
    this.id,
    this.puntos,
    this.preciogarrafon,
    this.typeGarrafon,
  }) : super(key: key);

  @override
  _VentaIUXState createState() => _VentaIUXState();
}

class _VentaIUXState extends State<VentaIUX> {
  int? countgarrafones = 1;
  double? preciogarrafon = 0;
  double? preciototal = 0;
  bool? estatus = false;
  String? mensanje = "";
  double _currentSlider = 1;
  String? puntosLocales;
  double? nuevoPrecio = 0;

  TextEditingController? numeroPuntos = new TextEditingController();

  final riveFileName = 'assets/img/newagua.riv';
  Artboard? _artboard;
  bool? tipodeVenta = false;

  @override
  void initState() {
    this.preciototal = widget.preciogarrafon! * countgarrafones!;
    this.puntosLocales = widget.puntos;
    this.nuevoPrecio = widget.preciogarrafon;
    //_loadRiveFile();
    super.initState();
  }

  /*void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();
    if (file.import(bytes)) {
      setState(() =>
          _artboard = file.mainArtboard..addController(SimpleAnimation('add')));
    }
  }*/

  bool closedialog = false;
  closeAlertDialog() {
    setState(() => closedialog = !closedialog);
  }

  @override
  Widget build(BuildContext context) {
    print("Puntos of QR: " + widget.puntos!);
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: estatus! ? 0.0 : 1.0,
        child: InkWell(
          onTap: () => this.numeroPuntos!.text.isEmpty != true
              ? addventa(Provider.of<User>(context, listen: false).getid,
                      int.parse(widget.id!))
                  .whenComplete(
                  () => showBarModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) {
                      return Congratulations(
                          puntos: this.puntosLocales!,
                          id: widget.id!,
                          numMore: int.parse(this.numeroPuntos!.text));
                    },
                  ),
                )
              : toast("Ingresa los puntos del cliente"),
          child: BotonAddCompra(
              size: size, estatus: estatus!, mensanje: mensanje!),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                height: size.height * 0.30,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/img/banner.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                height: size.height * 0.30,
                decoration:
                    BoxDecoration(color: Color(0xFFF3B5FFE).withOpacity(0.80)),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 80, left: 0, right: 0, bottom: 20),
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
                      nombre: widget.nombre!,
                      puntos: widget.puntos!,
                      size: size,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _artboard != null
                            ? Container(
                                padding:
                                    EdgeInsets.only(left: size.width * 0.09),
                                width: 300,
                                height: 300,
                                child: Rive(
                                  alignment: Alignment.centerLeft,
                                  artboard: _artboard!,
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
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_currentSlider <= 30) {
                                        _currentSlider += 1.0;
                                      }
                                      /* this.preciototal = widget.preciogarrafon *
                                          double.parse(
                                              _currentSlider.round().toString());
                                      print(this.preciototal); */
                                    });
                                    switchPrices(this.tipodeVenta!,
                                        _currentSlider, context);
                                    //_loadRiveFile();
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                        color: primarycolor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(Icons.arrow_drop_up,
                                        color: Colors.white, size: 35),
                                  ),
                                ),
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_currentSlider >= 1) {
                                        _currentSlider -= 1;
                                      }
                                      /* this.preciototal = widget.preciogarrafon *
                                          double.parse(
                                              _currentSlider.round().toString()); */
                                      print(this.preciototal);
                                    });
                                    switchPrices(
                                        tipodeVenta!, _currentSlider, context);
                                    //_loadRiveFile();
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                        color: primarycolor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(Icons.arrow_drop_down,
                                        color: Colors.white, size: 35),
                                  ),
                                ),
                              ],
                            )
                            /* Slider(
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
                              }), */
                            ),
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
                                    'Tipo de garrafón',
                                    style: textligth,
                                    textScaleFactor: 1.2,
                                  ),
                                  TextButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primarycolor),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    onPressed: () => null,
                                    icon: Icon(
                                      Icons.shopping_bag_outlined,
                                    ),
                                    label: Text('${widget.typeGarrafon}'),
                                  ),
                                ],
                              ),
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
                                    '\$${tipodeVenta! ? this.nuevoPrecio : widget.preciogarrafon}',
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
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          child: Container(
                            height: 100,
                            width: size.width * 0.8,
                            child: Form(
                                child: TextFormField(
                              textDirection: TextDirection.ltr,
                              autocorrect: true,
                              controller: numeroPuntos,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: secundarycolor, width: 2),
                                ),
                                focusColor: contraste,
                                hoverColor: primarycolor,
                                fillColor: terciarycolor,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: new BorderSide(color: contraste),
                                ),
                                counterStyle: TextStyle(
                                  fontSize: 20,
                                  color: contraste,
                                ),
                                prefixIcon: Icon(Icons.bolt),
                                labelText: "Numero de puntos",
                                contentPadding:
                                    EdgeInsets.only(top: 20, bottom: 20),
                              ),
                              style: TextStyle(
                                fontFamily: "SFSemibold",
                                color: terciarycolor,
                              ),
                              // ignore: missing_return
                              validator: (String? valor) {
                                if (valor!.isEmpty) {
                                  toast("El valor no puedo estar vacio");
                                }
                              },
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        context.watch<User>().getMinPoint <=
                                int.parse(this.puntosLocales!)
                            ? ShowPremios(
                                idcliente: widget.id!,
                                puntos: this.puntosLocales!,
                                scrollIs: "h",
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Proximos Premios',
                                    style: Regular_negra,
                                    textScaleFactor: 1.2,
                                  ),
                                  Container(
                                    child: ShowPremios(
                                      idcliente: widget.id!,
                                      puntos: "999",
                                      scrollIs: "f",
                                    ),
                                  ),
                                ],
                              ),
                        /*  ContainerPuntos(
                            puntos: this.puntosLocales,
                            id: widget.id,
                            size: size), */
                        estatus!
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'La compra se realizo con éxito',
                                      style: Regular_negra,
                                      textScaleFactor: 1.2,
                                    ),
                                    Icon(
                                      Icons.verified,
                                      color: Colors.greenAccent,
                                    )
                                  ],
                                ),
                              )
                            : (mensanje == "no"
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'La compra se no completo',
                                          style: Regular_negra,
                                          textScaleFactor: 1.2,
                                        ),
                                        Icon(
                                          Icons.replay_outlined,
                                          color: Colors.greenAccent,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                alignment: Alignment.centerRight,
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: widget.typeGarrafon == "Regarcado"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(
                              value: tipodeVenta!,
                              onChanged: (value) {
                                setState(() {
                                  tipodeVenta = value;
                                });
                                switchPrices(
                                    value, this._currentSlider, context);
                                print("Cambio de Venta: " + value.toString());
                              }),
                          Text(
                            !tipodeVenta! ? 'A domicilio' : 'Venta local',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'SFBlack'),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 1,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future addventa(int idR, int idC) async {
    print("idCliente: " +
        idC.toString() +
        ", IdRepartidor: " +
        idR.toString() +
        ", N. garrafones" +
        this._currentSlider.round().toString() +
        ", total: " +
        this.preciototal.toString());

    await http
        .post(Uri.parse("https://enfastmx.com/lacondesa/add_venta.php"), body: {
          "id_cliente": '' + idC.toString(),
          "id_repartidor": '' + idR.toString(),
          "garrafones": '' + this._currentSlider.round().toString(),
          "total": '' + this.preciototal.toString(),
          "puntosManual": this.numeroPuntos!.text,
          "tipoGarrafon": widget.typeGarrafon,
        })
        .then((response) {
          if (response.body == "nothing") {
            setState(() {
              mensanje = "No se pudo realizar la compra";
              estatus = true;
              toast("El cliente no entrado");
            });
          } else if (response.body == "ok") {
            setState(() {
              mensanje = "Compra realizada";
              estatus = true;
            });
            setState(() {
              int ptlocal = int.parse(widget.puntos.toString()) +
                  int.parse(this.numeroPuntos!.text);
              this.puntosLocales = ptlocal.toString();
            });
            //showMyDialog1();
          } else {
            setState(() {
              mensanje = "no";
            });
          }
        })
        .timeout(Duration(seconds: 40))
        .catchError((onError) {
          setState(() {
            mensanje = "no";
          });
          toast(
              "El servidor tardo mucho tiempo en responder intentalo de nuevo");
        });
  }

  switchPrices(bool isBol, double count, context) {
    if (isBol) {
      if (count == 2 || count == 3) {
        setState(() {
          this.preciototal = count * 13;
          this.nuevoPrecio = 13.00;
        });
      } else if (count >= 4) {
        setState(() {
          this.preciototal = count * 11;
          this.nuevoPrecio = 11.00;
        });
      } else if (count == 1) {
        setState(() {
          this.preciototal = count * widget.preciogarrafon!;
          this.nuevoPrecio = widget.preciogarrafon;
        });
      }
    } else {
      setState(() {
        this.preciototal = widget.preciogarrafon! * count;
        this.nuevoPrecio = widget.preciogarrafon;
      });
    }
  }
}

class Congratulations extends StatelessWidget {
  final String? puntos;
  final String? id;

  final int? numMore;

  Congratulations({
    @required this.puntos,
    @required this.id,
    @required this.numMore,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height * 1.5,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset("assets/icons/success.gif",
                    width: 50, height: 50)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Compra realizada con éxito. \nGracias por su preferencia',
                style: Semibol_negra,
                textScaleFactor: 1.3,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textScaleFactor: 1.3,
                    maxLines: 4,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Usted ha sumado ",
                      style: Regular_negra,
                      children: <TextSpan>[
                        TextSpan(
                          text: this.numMore.toString(),
                          style: Black_contraste,
                        ),
                        TextSpan(
                          text: " a su cuenta.",
                        ),
                        TextSpan(
                          text: "\n Ahora tiene ",
                          style: Regular_negra,
                        ),
                        TextSpan(
                          text: this.puntos,
                          style: Black_contraste,
                        ),
                        TextSpan(
                          text: " puntos en total",
                          style: Regular_negra,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Proximos Premios',
                    style: Regular_negra,
                    textScaleFactor: 1.2,
                  ),
                  Container(
                    child: ShowPremios(
                      idcliente: this.id!,
                      puntos: puntos!,
                      scrollIs: "h",
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Inicio(),
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      constraints: BoxConstraints(
                        maxHeight: size.height * 0.10,
                        minHeight: size.height * 0.06,
                      ),
                      height: 65,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: contraste,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Volver al inicio',
                            textScaleFactor: 1.2,
                            style: texttitle,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.qr_code_outlined, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //ContainerPuntos(puntos: this.puntos, id: this.id, size: size),
          ],
        ),
      ),
    );
  }
}

class ContainerPuntos extends StatelessWidget {
  ContainerPuntos({
    Key? key,
    @required this.puntos,
    @required this.id,
    @required this.size,
  }) : super(key: key);

  final String? id;
  final String? puntos;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return int.parse(this.puntos!) >= context.watch<User>().getMinPoint
        ? InkWell(
            onTap: () => print("object"),
            /*  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Premios(
                  puntos: this.puntos,
                  idcliente: this.id,
                ),
              ),
            ), */
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* TextButton(
                    onPressed: () => null,
                    child: int.parse(this.puntos) >=
                            context.watch<User>().getMinPoint
                        ? Text(
                            'Premios disponibles:    1',
                            style: TextStyle(
                                fontFamily: 'SFRegular',
                                fontWeight: FontWeight.w600,
                                color: primarycolor),
                            textScaleFactor: 1.2,
                          )
                        : Text(
                            'Premios disponibles: 0',
                            style: Black_negra,
                          ),
                  ) */
                  Container(
                    width: size!.width * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/icons/regalo.gif",
                          fit: BoxFit.cover,
                          width: 80,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: textcolorsubtitle,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            height: 1,
          );
  }
}

class ContainerCliente extends StatelessWidget {
  const ContainerCliente({
    Key? key,
    @required this.nombre,
    @required this.size,
    @required this.puntos,
  }) : super(key: key);

  final String? nombre;
  final String? puntos;
  final Size? size;

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
                this.nombre!,
                style: TextStyle(color: Colors.white, fontFamily: 'SFBold'),
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
                    width: size!.width * 0.2,
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
                              this.puntos! == "null" ? '0' : this.puntos!,
                              style: TextStyle(
                                  fontFamily: 'SFBold',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              textScaleFactor: 2,
                            )
                          ],
                        ),
                        Container(
                          width: size!.width,
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
    Key? key,
    @required this.size,
    @required this.estatus,
    @required this.mensanje,
  }) : super(key: key);

  final Size? size;
  final bool? estatus;
  final String? mensanje;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      constraints: BoxConstraints(
        maxHeight: size!.height * 0.12,
        minHeight: size!.height * 0.08,
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
            estatus! ? mensanje! : 'Confirmar compra',
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
