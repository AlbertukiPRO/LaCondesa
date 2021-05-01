import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/variables/BuilderVentas.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:lacondesa/variables/User.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Balance extends StatefulWidget {
  const Balance({Key key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  final riveFileName = 'assets/img/poins.riv';
  Artboard _artboard;

  Future httpresponsedata;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    httpresponsedata = getDataPoints(
        Provider.of<User>(context, listen: false).getid.toString());
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('Pointsnew'),
        ));
    }
  }

  Future getDataPoints(String id) async {
    try {
      http.Response response = await http.post(
          Uri.parse("https://enfastmx.com/lacondesa/getsaldoandpoints.php"),
          body: {
            "idrepartidor": id,
          });
      if (response.statusCode == 200) {
        var result = await jsonDecode(response.body);
        print(result);

        //context.read<User>().setpuntos =
        //context.read<User>().setPay =

        return result;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Header(size: size),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.12),
                width: size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      child: Text(
                        'Monto de hoy',
                        style: TextStyle(
                          fontFamily: 'SFRegular',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: httpresponsedata,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Error'));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                var mydata = snapshot.data;
                                return Text(
                                  '\$ ${mydata[0]['Ganancias']}',
                                  style: TextStyle(
                                      fontFamily: 'SFBlack',
                                      color: Colors.white),
                                  textScaleFactor: 2,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          Icon(
                            Icons.bar_chart_outlined,
                            color: Colors.white,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(25),
                      margin: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(
                            text:
                                'Excelente trabajo ${context.watch<User>().getnombre}, el saldo de dia de hoy es de ',
                            style: TextStyle(
                                fontFamily: 'SFSemibold',
                                color: textcolortitle,
                                fontSize: 15,
                                wordSpacing: 1.2),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\$500',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: secundarycolor,
                                      fontSize: 16)),
                              TextSpan(
                                  text:
                                      ' recuerda que debes precentar esta cantidad',
                                  style: TextStyle(
                                      fontFamily: 'SFSemibold',
                                      color: textcolortitle,
                                      fontSize: 15,
                                      wordSpacing: 1.2)),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            highlightColor: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.orangeAccent,
                            onTap: () => print('object'),
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: primarycolor,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Text(
                                'Corte de caja',
                                style: TextStyle(
                                    fontFamily: 'SFBlack', color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _artboard != null
              ? Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: Rive(
                          artboard: _artboard,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          FutureBuilder(
                            future: httpresponsedata,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Error'));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                var mydata = snapshot.data;
                                return Text(
                                  '${mydata[0]['Puntos']}',
                                  style: TextStyle(
                                    fontFamily: 'SFBold',
                                    color: primarycolor,
                                  ),
                                  textScaleFactor: 3,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          Text(
                            'Puntos totales',
                            style: texttitle2,
                            textScaleFactor: 1.3,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            width: size.width,
            child: Text(
              'Ultimas ventas',
              style: textsubtitlemini,
              textScaleFactor: 1.2,
            ),
          ),
          Container(
            width: size.width,
            child: const GetVentas(),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: size.height * 0.35,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/texture.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size.height * 0.35,
          decoration:
              BoxDecoration(color: Color(0xFFF3B5FFE).withOpacity(0.80)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      child: CachedNetworkImage(
                        imageUrl: context.watch<User>().getavatar == null
                            ? "https://www.w3schools.com/howto/img_avatar2.png"
                            : context
                                .watch<User>()
                                .getavatar, //Provider.of<User>(context).getavatar,
                        fit: BoxFit.cover,
                        width: size.width * 0.2,
                        height: size.height * 0.2,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${context.watch<User>().getnombre}',
                    style: TextStyle(
                        fontFamily: 'SFSemibold', color: Colors.white),
                    textScaleFactor: 1.2,
                  ),
                ],
              ),
              Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
