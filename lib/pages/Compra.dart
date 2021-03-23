import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/User.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class IuQRlector extends StatefulWidget {
  final String nombre;
  final String id;
  final String puntos;

  IuQRlector({
    Key key,
    this.nombre,
    this.id,
    this.puntos,
  }) : super(key: key);

  @override
  _IuQRlectorrState createState() => _IuQRlectorrState();
}

class _IuQRlectorrState extends State<IuQRlector> {
  int countgarrafones = 1;
  double preciogarrafon = 20;
  double preciotal = 0;

  upgarrafon() {
    setState(() {
      countgarrafones += 1;
      preciotal = preciogarrafon * countgarrafones;
    });
  }

  downgarrafon() {
    if (countgarrafones != 1) {
      setState(() {
        countgarrafones -= 1;
        if (preciotal > preciogarrafon) {
          preciotal -= preciogarrafon;
        }
      });
    }
  }

  final riveFileName = 'assets/img/agua.riv';
  Artboard _artboard;

  @override
  void initState() {
    super.initState();
    this.preciotal = preciogarrafon * countgarrafones;
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

  addventa(int idR, int idC) async {
    setState(() => estatus = true);
    print("idCliente: " +
        idC.toString() +
        ", IdRepartidor: " +
        idR.toString() +
        ", N. garrafones" +
        countgarrafones.toString() +
        ", total: " +
        preciotal.toString());
    await http
        .post(Uri.parse("https://enfastmx.com/lacondesa/add_venta.php"), body: {
      "id_cliente": '' + idC.toString(),
      "id_repartidor": '' + idR.toString(),
      "garrafones": '' + countgarrafones.toString(),
      "total": '' + preciotal.toString(),
    }).then((response) {
      print(response.body.toString());
      if (response.body == "nothing") {
        setState(() {
          mensanje = "No se pudo realisar la compra";
        });
      } else if (response.body == "ok") {
        setState(() {
          mensanje = "Compra realisaza";
          closedialog = !closedialog;
          estatus = false;
        });
      }
    }).catchError((onError) {
      setState(() {
        mensanje = "Error Api";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          addventa(
            Provider.of<User>(context, listen: false).getid,
            int.parse(widget.id),
          );
          print("llamando datos");
        },
        child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          decoration: BoxDecoration(
            color: contraste,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Text(
            'Comfirmar compra',
            style: texttitle,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            width: size.width,
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Venta de Garrafon',
                      style: TextStyle(
                          fontFamily: 'SFSemibold', color: primarycolor),
                      textScaleFactor: 2,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Total de puntos acumulados'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/coins.svg",
                          width: 20,
                          height: 20,
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
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => null,
                        child: Text(
                          'Premios disponibles: 0',
                          style: subtext,
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
                            InkWell(
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: textcolorsubtitle,
                                size: 25,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Seleccione el numero de Garrafones:',
                  style: texttitle2,
                  textScaleFactor: 1.2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'x ' + countgarrafones.toString(),
                        style: textsubtitlemini,
                        textScaleFactor: 2,
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
                            : Container(
                                child: SvgPicture.asset(
                                  "assets/img/botella-de-agua.svg",
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                      ),
                      Column(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(secundarycolor),
                              overlayColor:
                                  MaterialStateProperty.all(contraste),
                            ),
                            onPressed: () {
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
                            child: Icon(
                              Icons.expand_more,
                              size: 40,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(secundarycolor),
                              overlayColor:
                                  MaterialStateProperty.all(contraste),
                            ),
                            onPressed: () => downgarrafon(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
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
                      'Total de la compra: \$',
                      style: textsubtitlemini,
                      textScaleFactor: 1.2,
                    ),
                    Text(
                      '' + preciotal.toString(),
                      style: textsubtitlemini,
                      textScaleFactor: 1.4,
                    ),
                  ],
                ),
                estatus
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: 1,
                      ),
              ],
            ),
          ),
          closedialog
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: EdgeInsets.only(top: 150),
                  child: AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Compra Realizada con exito"),
                      ],
                    ),
                    content: Column(
                      children: [
                        Image.asset(
                          "assets/icons/success.gif",
                          width: 80,
                          height: 80,
                        ),
                        Text(
                            "Gracias por su compra \nUsted a sumado un punto a su cuenta un punto. En total tiene:"),
                        TextButton(
                            onPressed: () => null,
                            child: Text(
                              widget.puntos,
                              style: TextStyle(color: contraste),
                              textScaleFactor: 1.5,
                            )),
                        Text('Gracias !!!'),
                      ],
                    ),
                    actions: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Inicio'),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Cerrar'),
                        ),
                        onTap: () {
                          closeAlertDialog();
                        },
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
