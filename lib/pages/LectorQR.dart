import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'VentaScreen.dart';

class LectorQR extends StatefulWidget {
  const LectorQR();
  @override
  _LectorQRState createState() => _LectorQRState();
}

class _LectorQRState extends State<LectorQR> {
  ScanResult _scanResult;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: size.width,
          height: size.height,
          child: Container(
            height: size.height * 0.4,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                const NavBar(backbutton: true),
                Positioned(
                  top: 40,
                  child: Column(
                    children: [
                      context.watch<User>().getislectorQR == false
                          ? AnimatedOpacity(
                              opacity: context.watch<User>().getislectorQR
                                  ? 0.0
                                  : 1.0,
                              duration: Duration(seconds: 2),
                              child: Container(
                                width: size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 30),
                                  child: Card(
                                    color: Colors.white,
                                    child: _scanResult == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Esperado datos del QR",
                                                  style: textsubtitle,
                                                  textScaleFactor: 1.5,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Repartidor',
                                                  style: textsubtitlemini,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                CircularProgressIndicator(),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: _scanResult
                                                              .rawContent !=
                                                          ""
                                                      ? Text(
                                                          "Correto !!",
                                                          style: textsubtitle,
                                                          textScaleFactor: 1.5,
                                                        )
                                                      : Text(
                                                          "Se cerro el lector !!",
                                                          style: textsubtitle,
                                                          textScaleFactor: 1.5,
                                                        ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _scanResult
                                                                .rawContent !=
                                                            ""
                                                        ? contraste
                                                        : Colors.redAccent,
                                                  ),
                                                  child: _scanResult
                                                              .rawContent !=
                                                          ""
                                                      ? Icon(
                                                          LineIcons.check,
                                                          size: 25,
                                                          color: Colors.white,
                                                        )
                                                      : Icon(
                                                          Icons.close,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                /*Text('Contenido: ${_scanResult.rawContent}'),
                                            Text(
                                                'Formato: ${_scanResult.format.toString()}'),*/
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      context.watch<User>().getislectorQR
                          ? FutureBuilder<dynamic>(
                              future: getdatauser(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return snapshot.hasData
                                    ? iuQRlector(
                                        size: size, cuerpo: snapshot.data)
                                    /*:snapshot.data == "nothing"
                                    
                                        ? Center(
                                            child: Text(
                                              'No se encontro el cliente',
                                              style: textsubtitle,
                                            ),
                                          )
                                        : snapshot.hasError
                                            ? Center(
                                                child: Text(
                                                  'No se encontro el servidor',
                                                  style: textsubtitle,
                                                ),
                                              )*/
                                    : CircularProgressIndicator();
                              })
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          elevation: 2,
          onPressed: () {
            _scanCode();
          },
          child: Icon(Icons.camera),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _scanCode() async {
    var result = await BarcodeScanner.scan(
      options: ScanOptions(
        android: AndroidOptions(
          useAutoFocus: true,
        ),
      ),
    );
    setState(() {
      _scanResult = result;
    });
    context.read<User>().setiscodelectorQR = true;
    //print(result);
  }

  Future<dynamic> getdatauser() async {
    var arr = _scanResult.rawContent.split(".");
    print("QR contenido: " + arr[0] + arr[1] + arr[2]);
    var body = await http.post(
        Uri.parse("http://192.168.0.8/lacondesa/php/get_data_qr.php"),
        body: {
          "idcliente": arr[2],
        });
    return json.decode(body.body);
  }
}

class iuQRlector extends StatefulWidget {
  final Size size;
  dynamic cuerpo;

  iuQRlector({
    Key key,
    this.size,
    this.cuerpo,
  }) : super(key: key);

  @override
  _iuQRlectorState createState() => _iuQRlectorState();
}

class _iuQRlectorState extends State<iuQRlector> {
  int countgarrafones = 1;

  upgarrafon() {
    setState(() => countgarrafones += 1);
  }

  downgarrafon() {
    if (countgarrafones != 1) {
      setState(() => countgarrafones -= 1);
    }
  }

  Future addventa(int idR, int idC, int countGarr, double total) async {
    bool estatus;
    await http.post(Uri.parse(""), body: {
      "idCliten": idC,
      "idRepartido": idR,
      "countGarrafones": countGarr,
      "totalVendido": total,
    }).then((response) {
      if (response.body == "nothing") {
      } else if (response.body == "add") {
        estatus = true;
      } else {
        estatus = !estatus;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VentaScreen(
            estado: estatus,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CircleAvatar(
          radius: widget.size.aspectRatio * 80,
          backgroundImage: NetworkImage(context.watch<User>().getavatar),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cliente:',
              style: texttitle2,
              textScaleFactor: 1.2,
            ),
            Text(
              widget.cuerpo[0]['nombreCliente'].toString(),
              style: TextStyle(color: primarycolor, fontFamily: 'SFSemibold'),
              textScaleFactor: 1.2,
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Numero de Garrafones:',
          style: texttitle2,
          textScaleFactor: 1.2,
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primarycolor),
                      overlayColor: MaterialStateProperty.all(contraste),
                    ),
                    onPressed: () => upgarrafon(),
                    child: Icon(
                      Icons.expand_less_sharp,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primarycolor),
                      overlayColor: MaterialStateProperty.all(contraste),
                    ),
                    onPressed: () => downgarrafon(),
                    child: Icon(
                      Icons.expand_more,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                "assets/img/botella-de-agua.svg",
                width: widget.size.width * 0.2,
                height: widget.size.height * 0.18,
              ),
              Text(
                ' x ' + countgarrafones.toString(),
                style: textsubtitle,
                textScaleFactor: 2,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              'Total: \$',
              style: textsubtitlemini,
              textScaleFactor: 1.3,
            ),
            Text(
              '120.50',
              style: textsubtitlemini,
              textScaleFactor: 1.4,
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () => addventa(1, 2, 2, 150.45),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(contraste),
            overlayColor: MaterialStateProperty.all(contraste),
          ),
          child: Text(
            'Comfirmar compra',
            style: texttitle,
          ),
        ),
      ],
    );
  }
}
