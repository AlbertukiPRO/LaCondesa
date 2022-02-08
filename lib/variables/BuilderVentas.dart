import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/variables/User.dart';
import 'package:provider/provider.dart';
import 'package:lacondesa/variables/styles.dart';

Future<List<Ventas>> fetch(http.Client cliente, String idrepa) async {
  final response = await cliente
      .post(Uri.parse("https://enfastmx.com/lacondesa/get_ventas.php"), body: {
    "identificador": idrepa,
  });

  return compute(parseItem, response.body);
}

List<Ventas> parseItem(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Ventas>((json) => Ventas.fromJson(json)).toList();
}

class Ventas {
  final String? cliente;
  final String? numeroGarrafones;
  final String? fecha;
  final String? total;
  final String? idVenta;
  final String? tipoGarrafon;

  Ventas({
    this.cliente,
    this.numeroGarrafones,
    this.fecha,
    this.total,
    this.idVenta,
    this.tipoGarrafon,
  });

  factory Ventas.fromJson(Map<String, dynamic> json) {
    return Ventas(
      numeroGarrafones: json['NumeroGarrafones'] as String,
      total: json['totalventa'] as String,
      fecha: json['fecha_venta'] as String,
      cliente: json['nombreClientel'] as String,
      idVenta: json['idVenta'] as String,
      tipoGarrafon: json['tipoGarrafon'] as String,
    );
  }
}

class GetVentas extends StatelessWidget {
  const GetVentas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height, minHeight: 80),
      child: FutureBuilder<List<Ventas>>(
        future:
            fetch(http.Client(), Provider.of<User>(context).getid.toString()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              toast("Compruebe su conexión de red.");
              return SizedBox(
                width: 1,
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return snapshot.hasData
                  ? VentasList(lista: snapshot.data)
                  : CircularProgressIndicator();
            default:
              toast(snapshot.data.toString());
              return Center(child: Text(snapshot.data.toString()));
          }
        },
      ),
    );
  }
}

class VentasList extends StatelessWidget {
  final List<Ventas>? lista;
  VentasList({Key? key, this.lista}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: lista!.length,
      itemBuilder: (context, int? index) {
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 80,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/water-bottle.svg",
                      height: 70,
                      width: 70,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: terciarycolor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'x${lista![index!].numeroGarrafones}',
                        style: Semibold_blanca,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  'Garrafon ${lista![index].tipoGarrafon}',
                  style: Semibol_negra,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lista![index].fecha}',
                    style: textligth,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '+ \$ ${lista![index].total}',
                    style:
                        TextStyle(fontFamily: 'SFBlack', color: secundarycolor),
                    textScaleFactor: 1.2,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
