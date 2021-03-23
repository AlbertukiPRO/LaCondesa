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
  final String cliente;
  final String numeroGarrafones;
  final String fecha;
  final String total;
  final String idVenta;

  Ventas({
    this.cliente,
    this.numeroGarrafones,
    this.fecha,
    this.total,
    this.idVenta,
  });

  factory Ventas.fromJson(Map<String, dynamic> json) {
    return Ventas(
      numeroGarrafones: json['NumeroGarrafones'] as String,
      total: json['totalventa'] as String,
      fecha: json['fecha_venta'] as String,
      cliente: json['nombreClientel'] as String,
      idVenta: json['idVenta'] as String,
    );
  }
}

class GetVentas extends StatelessWidget {
  const GetVentas({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future:
            fetch(http.Client(), Provider.of<User>(context).getid.toString()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: TextButton(
                  onPressed: () => null,
                  child: Text('Comprueba tu conexión'),
                ),
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return snapshot.hasData
                  ? VentasList(lista: snapshot.data)
                  : CircularProgressIndicator();
            default:
              return Center(child: Text(snapshot.data.toString()));
          }
        },
      ),
    );
  }
}

class VentasList extends StatelessWidget {
  final List<Ventas> lista;
  VentasList({Key key, this.lista}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => null,
                      child: Text(
                        'Código de venta: #CONSA.${lista[index].idVenta}',
                      ),
                    ),
                    Text(
                      'Cantidad de Garrafones: ${lista[index].numeroGarrafones}',
                      style: subtext,
                      textScaleFactor: 1,
                    ),
                    SvgPicture.asset(
                      "assets/img/botella-de-agua.svg",
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(
                      'Nombre del Cliente:',
                      style: subtext,
                      textScaleFactor: 1,
                    ),
                    Text(
                      '${lista[index].cliente}:',
                      style: textligth,
                      textScaleFactor: 1,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total de la compra: ',
                          style: subtext,
                          textScaleFactor: 1,
                        ),
                        Text(
                          '\$${lista[index].total}',
                          style: textligth,
                          textScaleFactor: 1.8,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
