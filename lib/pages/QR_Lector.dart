import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lacondesa/pages/Compra.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Home.dart';

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

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getid == null
        ? buildProvier(context)
        : print('');
  }

  var bodyhtp;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> stopCamera() async {
    await controller.pauseCamera();
  }

  Future<dynamic> getdatauser() async {
    var arr = result.code.split(".");
    print("QR contenido: " + arr[0] + arr[1] + arr[2]);
    var body = await http.post(
        Uri.parse("https://enfastmx.com/lacondesa/get_data_qr.php"),
        body: {
          "idcliente": arr[2],
        });
    setState(() {
      bodyhtp = json.decode(body.body);
    });
    return json.decode(body.body);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: result != null
          ? FutureBuilder<dynamic>(
              future: getdatauser(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? bodyhtp[0]['idCliente'] != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: FloatingActionButton(
                              elevation: 8,
                              backgroundColor: contraste,
                              child: Icon(Icons.arrow_forward_ios_outlined),
                              onPressed: () {
                                var mydata = snapshot.data;
                                print(
                                    "QR_Lector => \"Datos del Cliente Segun su QR\":" +
                                        mydata[0]['idCliente'] +
                                        mydata[0]['nombreCliente'] +
                                        mydata[0]['puntos']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IuQRlector(
                                      id: '' +
                                          mydata[0]['idCliente'].toString(),
                                      nombre: '' +
                                          mydata[0]['nombreCliente'].toString(),
                                      puntos: mydata[0]['puntos'].toString() ==
                                              'null'
                                          ? "null"
                                          : mydata[0]['puntos'].toString(),
                                      preciogarrafon: Provider.of<User>(context,
                                              listen: false)
                                          .getpreciogarrafon,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Container(
                              width: size.width * 0.5,
                              child: TextButton(
                                onPressed: () => null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Este código no funciona',
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.not_interested_sharp),
                                  ],
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[700]),
                                  overlayColor:
                                      MaterialStateProperty.all(contraste),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                            ),
                          )
                    : Center(child: CircularProgressIndicator());
              })
          : Text(''),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
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
                              return describeEnum(snapshot.data) == "back"
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
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 5,
            top: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: primarycolor,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
                stopCamera();
              },
            ),
          ),
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
      stopCamera();
      Vibration.vibrate(duration: 100);
    });
  }
}
