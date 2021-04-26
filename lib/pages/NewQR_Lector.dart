import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lacondesa/pages/Compra.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/IU_NEW.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:alert/alert.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRNEW extends StatefulWidget {
  const QRNEW();
  @override
  _QRNEWState createState() => _QRNEWState();
}

class _QRNEWState extends State<QRNEW> {
  String _scanBarcode = 'Unknown';
  bool estado;
  final riveFileName = 'assets/img/qr_phone.riv';
  Artboard _artboard;
  var mydata;

  void changeStado(status) {
    setState(() => this.estado = status);
  }

  fetchData(context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();

    if (disk.getDouble('keypreciogarr') == null ||
        disk.getInt('keyminpt') == null ||
        disk.getDouble('keyrecarga') == null) {
      downloadPrices(context);
    } else {
      var res = _scanBarcode.split(".");
      if (res.length != 1 && res[0] == "cliente") {
        barboottom(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getid == null
        ? buildProvier(context)
        : print('');
    _loadRiveFile('QR SCANNER');
    scanQR().whenComplete(
      () => getdatauser().whenComplete(() => fetchData(context)),
    );
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

  void _loadRiveFile(String animation) async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation(animation),
        ));
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cerrar', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'La versión de este andriod es invalida';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> getdatauser() async {
    var arr = _scanBarcode.split(".");
    arr[0] != "cliente" ??
        Alert(message: "Este QR no pertenese al sistema").show();
    if (arr.length != 3 && arr[0] != "cliente") {
      _loadRiveFile('ERROR');
      Alert(message: 'El qr no pertencese a Purificadora la condesa').show();
    } else {
      _loadRiveFile('Succes');
    }
    print("Lector_QR ()=> contenido: " + arr[0] + arr[1] + arr[2]);
    await http
        .post(Uri.parse("https://enfastmx.com/lacondesa/get_data_qr.php"),
            body: {
              "idcliente": arr[2],
            })
        .then((datos) => setState(() {
              mydata = json.decode(datos.body);
              this.estado = true;
            }))
        .timeout(Duration(seconds: 40))
        .catchError((onError) {
          Alert(
                  message:
                      'Error, la conexion de red fallo o el qr esta corronpido')
              .show();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Inicio(),
            ),
          ),
        ),
        body: Center(
          child: Container(
            width: 800,
            height: 800,
            child: Rive(
              artboard: _artboard,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }

  Future<void> downloadPrices(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: texttitle2,
          title: Text(
            "Actualizando Precios",
            textAlign: TextAlign.center,
            textScaleFactor: 1.2,
          ),
          content: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.15),
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<bool>(
                  future: pricesIOT(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Column(children: [
                          Text('Conexión establecida con exito '),
                          SizedBox(
                            height: 10,
                          ),
                          !snapshot.data
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber),
                                )
                              : SizedBox(
                                  width: 1,
                                ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              barboottom(context);
                            },
                            child: Text('Cerrar'),
                          )
                        ]);
                        break;
                      case ConnectionState.waiting:
                        return Column(children: [
                          Text('Conectando..'),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ]);
                      default:
                        return Text('data');
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> barboottom(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                "Selecciona el garrafon",
                style: texttitle2,
                textScaleFactor: 1.2,
              ),
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IuQRlector(
                    id: '' + mydata[0]['idCliente'].toString(),
                    nombre: '' + mydata[0]['nombreCliente'].toString(),
                    puntos: mydata[0]['puntos'].toString() == 'null'
                        ? "null"
                        : mydata[0]['puntos'].toString(),
                    preciogarrafon: Provider.of<User>(context, listen: false)
                        .getpreciogarrafon,
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/water-bottle.svg",
                      width: 80,
                      height: 80,
                    ),
                    Text(
                      'Garrafon Nuevo',
                      style: subtext,
                      textScaleFactor: 1.1,
                    ),
                    Text(
                      '\$${Provider.of<User>(context, listen: false).getpreciogarrafon}',
                      style: dinerofont,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Color(0xfffdcdde1),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/hydro-power.svg",
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    'Garrafon recargado',
                    style: subtext,
                    textScaleFactor: 1.1,
                  ),
                  Text(
                    '\$ ${Provider.of<User>(context, listen: false).getpreciogarrafon}',
                    /*{context.watch<User>().getcostoRecarga}*/
                    style: dinerofont,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Color(0xfffdcdde1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> pricesIOT() async {
    bool status = false;
    SharedPreferences disk = await SharedPreferences.getInstance();
    await http
        .post(
            Uri.parse("https://enfastmx.com/lacondesa/get_configuraciones.php"))
        .then((data) async {
          switch (data.statusCode) {
            case 200:
              var result = jsonDecode(data.body);
              print(result);

              try {
                Provider.of<User>(context, listen: false).setPreciogarrafon =
                    double.parse(result[0]['preciogr'].toString());
                Provider.of<User>(context, listen: false).setMinpoint =
                    int.parse(result[0]['minpt'].toString());
                Provider.of<User>(context, listen: false).setCostoRecarga =
                    double.parse(result[0]['recarga'].toString());

                await disk.setDouble('keypreciogarr',
                    double.parse(result[0]['preciogr'].toString()));
                await disk.setInt(
                    'keyminpt', int.parse(result[0]['minpt'].toString()));
                await disk.setDouble('keyrecarga',
                    double.parse(result[0]['recarga'].toString()));

                status = true;

                Alert(message: 'Server ready: ').show();
              } catch (e) {
                Alert(message: 'Error Descargando: ' + e.toString()).show();
                status = false;
                print(e.toString());
              }

              break;
            case 400:
              Alert(message: 'Descarga fallida, sin servicio').show();
              status = false;
              break;
            case 500:
              Alert(message: 'Error en el servidor').show();
              break;
            default:
              status = false;
          }
        })
        .timeout(Duration(seconds: 60))
        .catchError((onError) {
          Alert(message: 'Descarga fallida reinicia la aplicación').show();
          status = false;
        });
    return status;
  }
}
