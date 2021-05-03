import 'dart:convert';
import 'dart:math';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/pages/Inicio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vibration/vibration.dart';

Future<List<Premios>> fetchPremios(http.Client cliente, String puntos) async {
  final response = await cliente
      .post(Uri.parse("https://enfastmx.com/lacondesa/get_premios.php"), body: {
    "points": puntos,
  });
  return compute(parseItem, response.body);
}

List<Premios> parseItem(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Premios>((json) => Premios.fromJson(json)).toList();
}

class Premios {
  final String idPremios;
  final String puntosRequeridos;
  final String nombreProducto;
  final String imgProducto;
  final String descripcion;

  Premios(
      {this.idPremios,
      this.puntosRequeridos,
      this.nombreProducto,
      this.imgProducto,
      this.descripcion});

  factory Premios.fromJson(Map<String, dynamic> json) {
    return Premios(
      idPremios: json['idPremios'] as String,
      nombreProducto: json['nombreProducto'] as String,
      imgProducto: json['imgProducto'] as String,
      descripcion: json['descripcion'] as String,
      puntosRequeridos: json['puntosRequeridos'] as String,
    );
  }
}

class ShowPremios extends StatefulWidget {
  final String idcliente;
  final String puntos;
  final String scrollIs;
  const ShowPremios({Key key, this.puntos, this.idcliente, this.scrollIs})
      : super(key: key);

  @override
  ShowPremiosState createState() => ShowPremiosState();
}

class ShowPremiosState extends State<ShowPremios> {
  Future<List<Premios>> preloadDatos;

  @override
  void initState() {
    super.initState();
    preloadDatos = _getData();
  }

  Future<List<Premios>> _getData() async {
    return await fetchPremios(http.Client(), widget.puntos);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Premios>>(
      future: preloadDatos,
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
                ? Container(
                    width: size.width,
                    height: size.height * 0.55,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: GetPremios(
                      lista: snapshot.data,
                      idCliente: widget.idcliente,
                      scrool: widget.scrollIs,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Text('No fue posible cargar los datos'),
                  )
            : CircularProgressIndicator();
      },
    );
  }
}

// ignore: must_be_immutable
class GetPremios extends StatefulWidget {
  List<Premios> lista;
  final String scrool;
  final String idCliente;
  GetPremios({Key key, this.lista, this.idCliente, this.scrool})
      : super(key: key);

  @override
  _GetPremiosState createState() => _GetPremiosState();
}

class _GetPremiosState extends State<GetPremios> {
  PageController _pageController;

  int active = 0;

  double viewportfraction = 0.8;

  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: viewportfraction,
    )..addListener(() {
        setState(() {
          pageOffset = _pageController.page;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      allowImplicitScrolling: true,
      scrollDirection: widget.scrool == "h" ? Axis.horizontal : Axis.vertical,
      itemCount: widget.lista.length,
      onPageChanged: (value) {
        setState(() {
          this.active = value;
        });
      },
      itemBuilder: (context, index) {
        double scale = max(viewportfraction,
            (1 - (pageOffset - index).abs()) + viewportfraction);
        double angle = (pageOffset - index).abs();
        if (angle > 0.5) {
          angle = 1 - angle;
        }
        return InkWell(
          onTap: () => null,
          child: Container(
            padding: EdgeInsets.only(
              right: 10,
              left: 10,
              top: 50 - scale * 25,
              bottom: 50 - scale * 25,
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(
                  3,
                  2,
                  0.0001,
                )
                ..rotateY(angle),
              alignment: Alignment.center,
              child: Material(
                elevation: 2,
                animationDuration: Duration(seconds: 1),
                borderRadius: BorderRadius.circular(20),
                child: ItemPageView(
                  givemy: widget.scrool == "h" ? true : false,
                  id: int.parse(widget.lista[index].idPremios),
                  nombre: widget.lista[index].nombreProducto,
                  image: widget.lista[index].imgProducto,
                  descripcion: widget.lista[index].descripcion,
                  puntosReque: widget.lista[index].puntosRequeridos,
                  idCliente: widget.idCliente,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemPageView extends StatefulWidget {
  const ItemPageView({
    Key key,
    this.image,
    this.precio,
    this.nombre,
    this.descripcion,
    this.puntosReque,
    this.id,
    this.idCliente,
    this.givemy,
  }) : super(key: key);

  final String image;
  final String precio;
  final String nombre;
  final String descripcion;
  final String puntosReque;
  final int id;
  final bool givemy;

  final String idCliente;

  @override
  _ItemPageViewState createState() => _ItemPageViewState();
}

class _ItemPageViewState extends State<ItemPageView> {
  bool isCanjeo = false;

  Future<bool> getPremio(
      String idCliente, String puntos, String producto) async {
    setState(() => isCanjeo = !isCanjeo);
    try {
      http.Response response = await http.post(
          Uri.parse("https://enfastmx.com/lacondesa/canjeopuntos.php"),
          body: {
            "idcliente": idCliente,
            "puntosmenos": puntos,
            "producto": producto,
          });
      if (response.statusCode == 200) {
        print(response.body);
        Vibration.vibrate(duration: 100);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sizewidth = MediaQuery.of(context).size.width;
    final double sizealto = MediaQuery.of(context).size.height;
    return Container(
      width: sizewidth,
      height: sizealto,
      child: InkWell(
        onTap: () => null,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: sizewidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: sizewidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment(0.0, 0.0),
                  colors: [
                    const Color.fromRGBO(0, 0, 0, 0.9595),
                    const Color.fromRGBO(0, 0, 0, 0),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              width: sizewidth,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/coins.svg",
                          width: 10,
                          height: 10,
                        ),
                        Text(
                          widget.puntosReque,
                          style: TextStyle(
                              fontFamily: 'SFBold', color: Colors.white),
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      widget.givemy
                          ? getPremio(
                              widget.idCliente,
                              widget.puntosReque,
                              widget.nombre,
                            ).whenComplete(() {
                              showMaterialModalBottomSheet(
                                expand: true,
                                context: context,
                                builder: (context) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Usted recibirá',
                                            style: Semibol_negra,
                                            textScaleFactor: 1.5,
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Inicio(),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Listo',
                                                  textAlign: TextAlign.center,
                                                ),
                                                Icon(Icons.check),
                                              ],
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primarycolor),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      contraste),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: sizewidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/coins.svg",
                                              width: 70,
                                              height: 70,
                                            ),
                                            Text(
                                              'Usted a canjeado ${widget.puntosReque}',
                                              style: Semibol_gris,
                                              textScaleFactor: 1.5,
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: sizewidth * 0.8,
                                        height: sizealto * 0.5,
                                        child: InkWell(
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: widget.image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Container(
                                                    width: sizewidth,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: sizewidth,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment(0.0, 0.0),
                                                    colors: [
                                                      const Color.fromRGBO(
                                                          0, 0, 0, 0.9595),
                                                      const Color.fromRGBO(
                                                          0, 0, 0, 0),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              Container(
                                                width: sizewidth,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.3),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/coins.svg",
                                                            width: 10,
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            widget.puntosReque,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'SFBold',
                                                                color: Colors
                                                                    .white),
                                                            textScaleFactor: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () =>
                                                          print('beto'),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          LineIcons.heart,
                                                          color: Colors.pink,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: sizealto * 0.03,
                                                child: Container(
                                                  width: sizewidth,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      20),
                                                          child: TextButton(
                                                            onPressed: () =>
                                                                null,
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          primarycolor),
                                                              overlayColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          contraste),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            child:
                                                                Text('Nuevo'),
                                                          )),
                                                      Container(
                                                        width: sizewidth * 0.8,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 0,
                                                                horizontal: 20),
                                                        child: Text(
                                                          widget.nombre,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            height: 1,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                          textScaleFactor: 2.2,
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: sizewidth * 0.6,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Text(
                                                          widget.descripcion,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'SFLigera',
                                                              color:
                                                                  Colors.white),
                                                          textScaleFactor: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                          : print("object");
                    },
                    child: this.isCanjeo
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lo quiero',
                                textAlign: TextAlign.center,
                              ),
                              Icon(Icons.card_giftcard),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: sizealto * 0.03,
              child: Container(
                width: sizewidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextButton(
                          onPressed: () => null,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primarycolor),
                            overlayColor: MaterialStateProperty.all(contraste),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text('Nuevo'),
                        )),
                    Container(
                      width: sizewidth * 0.8,
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Text(
                        widget.nombre,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                        ),
                        textAlign: TextAlign.left,
                        textScaleFactor: 2.2,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      width: sizewidth * 0.6,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        widget.descripcion,
                        style: TextStyle(
                            fontFamily: 'SFLigera', color: Colors.white),
                        textScaleFactor: 1,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
