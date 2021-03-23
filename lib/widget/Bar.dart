import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lacondesa/variables/styles.dart';

class BarRepartidor extends StatelessWidget {
  const BarRepartidor({
    Key key,
    @required this.nombre,
    @required this.avatar,
  }) : super(key: key);

  final String nombre;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  this.nombre == null ? "" : this.nombre,
                  style: textsubtitle,
                  textScaleFactor: 1.4,
                ),
                Text(
                  'Aplicación Repartidor',
                  style: textsubtitlemini,
                  textScaleFactor: 1.3,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  child: Hero(
                    tag: 'fotoprofile',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: size.width * 0.2,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: avatar,
                          fit: BoxFit.cover,
                          width: size.width * 0.2,
                          height: size.height * 0.1,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
