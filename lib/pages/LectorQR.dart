import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
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
                      AnimatedOpacity(
                        opacity: 1.0,
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
                                            "Escaneé el QR",
                                            style: textsubtitle,
                                            textScaleFactor: 1.5,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Lector de QR - La condesa',
                                            style: textsubtitlemini,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                      _scanResult != null
                          ? FutureBuilder<dynamic>(
                              future: getdatauser(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return snapshot.hasData
                                    ? IuQRlector(
                                        size: size,
                                        cuerpo: snapshot.data,
                                      )
                                    : Text(
                                        'Se cerro el lector..',
                                        style: texttitle2,
                                        textScaleFactor: 1.3,
                                      );
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
          child: Icon(LineIcons.camera),
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
        Uri.parse("http://192.168.0.4/lacondesa/php/get_data_qr.php"),
        body: {
          "idcliente": arr[2],
        });
    return json.decode(body.body);
  }
}

// ignore: must_be_immutable
class IuQRlector extends StatefulWidget {
  final Size size;
  dynamic cuerpo;

  IuQRlector({
    Key key,
    this.size,
    this.cuerpo,
  }) : super(key: key);

  @override
  _IuQRlectorrState createState() => _IuQRlectorrState();
}

class _IuQRlectorrState extends State<IuQRlector> {
  int countgarrafones = 1;

  upgarrafon() {
    setState(() => countgarrafones += 1);
  }

  downgarrafon() {
    if (countgarrafones != 1) {
      setState(() => countgarrafones -= 1);
    }
  }

  final riveFileName = 'assets/img/agua.riv';
  Artboard _artboard;

  @override
  void initState() {
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('bote'),
        ));
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
                    onPressed: () {
                      //_togglePlay();
                      _loadRiveFile();
                      upgarrafon();
                    },
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
              Padding(
                padding: const EdgeInsets.all(0),
                child: _artboard != null
                    ? Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Rive(
                            artboard: _artboard,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Container(),
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
