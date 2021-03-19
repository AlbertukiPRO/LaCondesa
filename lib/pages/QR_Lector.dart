import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';

import 'VentaScreen.dart';

class QRLector extends StatefulWidget {
  const QRLector({Key key}) : super(key: key);

  @override
  _QRLectorState createState() => _QRLectorState();
}

class _QRLectorState extends State<QRLector> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flash = false;
  bool showcamera = false;
  var bodyhtp;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Future<dynamic> getdatauser() async {
    var arr = result.code.split(".");
    print("QR contenido: " + arr[0] + arr[1] + arr[2]);
    var body = await http.post(
        Uri.parse("http://192.168.0.4/lacondesa/php/get_data_qr.php"),
        body: {
          "idcliente": arr[2],
        });
    setState(() {
      bodyhtp = json.decode(body.body);
    });
    return json.decode(body.body);
  }

  repaint() {
    setState(() {
      showcamera = !showcamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: showcamera
          ? IuQRlector(
              size: size,
              cuerpo: bodyhtp,
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: size.height,
                  width: size.width,
                  child: _buildQrView(context),
                ),
                Positioned(
                  top: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (result != null)
                        FutureBuilder<dynamic>(
                            future: getdatauser(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              controller.stopCamera();
                              return snapshot.hasData
                                  ? bodyhtp[0]['id'] != null
                                      ? Text('Sin datos')
                                      : TextButton(
                                          onPressed: () {
                                            repaint();
                                          },
                                          child: Text('Continuar'),
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
                                        )
                                  : Center(
                                      child: Text('Nada'),
                                    );
                            }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {
                                  flash = !flash;
                                });
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Icon(
                                    flash ? Icons.flash_off : Icons.flash_on,
                                    color: Colors.white,
                                    size: 25,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await controller?.flipCamera();
                                  setState(() {});
                                },
                                child: FutureBuilder(
                                  future: controller?.getCameraInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return describeEnum(snapshot.data) ==
                                              "back"
                                          ? Icon(
                                              Icons.photo_camera_back,
                                              color: Colors.white,
                                              size: 25,
                                            )
                                          : Icon(
                                              Icons.camera_front,
                                              color: Colors.white,
                                              size: 25,
                                            );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
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
                        backgroundColor:
                            MaterialStateProperty.all(primarycolor),
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
                        backgroundColor:
                            MaterialStateProperty.all(primarycolor),
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
      ),
    );
  }
}