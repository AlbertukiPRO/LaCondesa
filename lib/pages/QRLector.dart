import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/pages/Inicio.dart';
import 'package:lacondesa/pages/SeleccionGarrafon.dart';
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

  fetchData(context) async {
    SharedPreferences disk = await SharedPreferences.getInstance();

    if (disk.getDouble('keypreciogarr') == null ||
        disk.getInt('keyminpt') == null ||
        disk.getDouble('keyrecarga') == null) {
      downloadPrices(context);
    } else {
      var res = _scanBarcode.split(".");
      if (res[0] == "http://cliente") {
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
    print("Lector QR ()=> dice [ " +
        disk.getString('nombrekey') +
        disk.getString('avatarkey') +
        "]");
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
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cerrar', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      toast('La versión de este andriod es invalida');
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      vibrar();
    });
  }

  Future<void> getdatauser() async {
    toast("Espere...");
    var arr = _scanBarcode.split(".");
    if (arr[0] != "http://cliente") {
      _loadRiveFile('ERROR');
      toast("Este QR no pertenece a purificadora la condesa");
    } else
      _loadRiveFile('Succes');
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
        .catchError((onError) =>
            toast('Error, la conexión de red fallo o el QR esta dañado'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            height: 80,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => toast(_scanBarcode),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.construction_outlined, color: primarycolor),
                      Text(
                        'Mostrar datos',
                        style: textligth,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRNEW())),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: primarycolor,
                      ),
                      Text(
                        'Scanear de nuevo',
                        style: textligth,
                      )
                    ],
                  ),
                ),
              ],
            )),
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/img/b216c450da0e3bd5ca578f0bdccd841f.png"),
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(right: 11),
              child: Rive(
                artboard: _artboard,
                fit: BoxFit.contain,
              ),
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
          titleTextStyle: Semibol_negra,
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
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Selecciona el garrafón",
                  style: Semibol_negra,
                  textScaleFactor: 1.2,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VentaIUX(
                      id: '' + mydata[0]['idCliente'].toString(),
                      nombre: '' + mydata[0]['nombreCliente'].toString(),
                      puntos: mydata[0]['puntos'].toString() == 'null'
                          ? "null"
                          : mydata[0]['puntos'].toString(),
                      preciogarrafon: Provider.of<User>(context, listen: false)
                          .getpreciogarrafon,
                      typeGarrafon: 'Nuevo',
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
                        style: Regular_negra,
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        '\$${Provider.of<User>(context, listen: false).getpreciogarrafon}',
                        style: Black_contraste,
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
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VentaIUX(
                      id: '' + mydata[0]['idCliente'].toString(),
                      nombre: '' + mydata[0]['nombreCliente'].toString(),
                      puntos: mydata[0]['puntos'].toString() == 'null'
                          ? "null"
                          : mydata[0]['puntos'].toString(),
                      preciogarrafon: Provider.of<User>(context, listen: false)
                          .getcostoRecarga,
                      typeGarrafon: 'Regarcado',
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
                        "assets/icons/hydro-power.svg",
                        width: 80,
                        height: 80,
                      ),
                      Text(
                        'Garrafon Rellenado',
                        style: Regular_negra,
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        '\$ ${Provider.of<User>(context, listen: false).getcostoRecarga}',
                        /*{context.watch<User>().getcostoRecarga}*/
                        style: Black_contraste,
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
            ],
          ),
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

                toast("Listo.");
              } catch (e) {
                Alert(message: 'Error Descargando: ' + e.toString()).show();
                status = false;
                print(e.toString());
              }

              break;
            case 400:
              toast("Descarga fallida, Inténtelo más tarde");
              status = false;
              break;
            case 500:
              toast("Error con el servidor");
              break;
            default:
              status = false;
          }
        })
        .timeout(Duration(seconds: 60))
        .catchError((onError) {
          toast("Descarga fallida reinicia la aplicación");
          status = false;
        });
    return status;
  }
}
