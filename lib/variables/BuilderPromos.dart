import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/variables/styles.dart';

Future<List<Promos>> fetch(http.Client cliente) async {
  final response = await cliente
      .get(Uri.parse("https://enfastmx.com/lacondesa/get_promos.php"));

  return compute(parseItem, response.body);
}

List<Promos> parseItem(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promos>((json) => Promos.fromJson(json)).toList();
}

class Promos {
  final String? id;
  final String? nombre;
  final String? img;
  final String? precioviejo;
  final String? precionuevo;
  final String? descripcion;

  Promos(
      {this.precioviejo,
      this.precionuevo,
      this.id,
      this.nombre,
      this.img,
      this.descripcion});

  factory Promos.fromJson(Map<String, dynamic> json) {
    return Promos(
      id: json['idOfertas'] as String,
      nombre: json['NombreOferta'] as String,
      img: json['imgoferta'] as String,
      descripcion: json['descripcion'] as String,
      precioviejo: json['precioViejo'] as String,
      precionuevo: json['precioNuevo'] as String,
    );
  }
}

class GetPromos extends StatefulWidget {
  const GetPromos({Key? key}) : super(key: key);

  @override
  _GetPromosState createState() => _GetPromosState();
}

class _GetPromosState extends State<GetPromos> {
  Future<List<Promos>>? listasave;

  @override
  void initState() {
    super.initState();
    listasave = _getData();
  }

  Future<List<Promos>> _getData() async {
    return await fetch(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Promos>>(
        future: listasave,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? PromoList(lista: snapshot.data!)
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

class PromoList extends StatelessWidget {
  final List<Promos>? lista;
  const PromoList({Key? key, this.lista}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: lista!.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: InkWell(
                onTap: () => print(lista![index].id),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: lista![index].img!,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 40,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            lista![index].nombre!,
                            style: Semibol_negra,
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            'Precio viejo: \$' + lista![index].precioviejo!,
                            style: Semibol_gris,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ahora:',
                      style: Regular_negra,
                    ),
                    Text(
                      '\$' + lista![index].precionuevo!,
                      style: Black_contraste,
                      textScaleFactor: 1.4,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
