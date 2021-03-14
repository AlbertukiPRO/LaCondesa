import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacondesa/pages/Home.dart';
import 'package:lacondesa/variables/styles.dart';
import 'package:lacondesa/widget/ButtonForm.dart';
import 'package:lacondesa/widget/NavBar.dart';
import 'package:lacondesa/widget/TextBox.dart';
import 'package:lacondesa/widget/TextBoxPass.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkeyRegiter = GlobalKey<FormState>();
  bool showtextpassword = false;

  TextEditingController nombreInput = new TextEditingController();
  TextEditingController phoneInput = new TextEditingController();
  TextEditingController claveinput = new TextEditingController();
  TextEditingController claveinputrepete = new TextEditingController();
  TextEditingController direccionInput = new TextEditingController();

  void showpassword() {
    setState(() => showtextpassword = !showtextpassword);
  }

  void editnumber() {
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'MX',
      newMask: '+0 (000) 000 00 00',
    );
  }

  static final String uploadEndPoint =
      'http://192.168.0.4/lacondesa/php/registro_repartidor.php';
  final picker = ImagePicker();
  String status = "";
  File _images;
  String base64Image;
  File tmpFile;
  bool succesfull = false;
  bool errorregiter = false;
  String errMessage = 'Error Uploading Image';
  String nombreImageAvatar = "";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images = File(pickedFile.path);
        tmpFile = _images;
        base64Image = base64Encode(_images.readAsBytesSync());
      } else {
        print('No image selected.');
      }
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    print(fileName);
    upload(fileName);
    print(fileName);
    setState(() => nombreImageAvatar = fileName);
  }

  upload(String fileName) {
    http.post(Uri.parse(uploadEndPoint), body: {
      "image": base64Image,
      "name": fileName,
      "nombre": nombreInput.text,
      "phone": phoneInput.text,
      "clave": claveinput.text,
      "direccion": direccionInput.text,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      print(result.body);
      if (result.body == "ok") {
        setState(() => succesfull = !succesfull);
      } else {
        setState(() {
          errorregiter = true;
          setStatus(result.body);
        });
      }
    }).catchError((error) {
      setStatus(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: succesfull == false
              ? Container(
                  height: size.height,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const NavBar(
                        backbutton: true,
                      ),
                      Positioned(
                        top: 70,
                        child: Container(
                          height: size.height * 1,
                          width: size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Registro',
                                      style: textsubtitle,
                                      textScaleFactor: 1.5,
                                    ),
                                    Text(
                                      'Repartidores',
                                      style: textsubtitlemini,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      width: size.width,
                                      color: Colors.grey.shade200,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Form(
                                      key: _formkeyRegiter,
                                      child: Column(
                                        children: [
                                          textbox(
                                            nombreInput: nombreInput,
                                            textlabel: 'Nombre de Usuario',
                                            errorlabel:
                                                'El nombre de usuario no es valido',
                                            prefixicono: Icon(
                                              LineIcons.userAlt,
                                              color: secundarycolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextboxPassw(
                                            nombreInput: claveinput,
                                            errorlabel:
                                                'La contraseña no es valida',
                                            textlabel: 'Contraseña',
                                            prefixicono: Icon(
                                              LineIcons.key,
                                              color: secundarycolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextboxPassw(
                                            nombreInput: claveinputrepete,
                                            textlabel: 'Repita la contraseña',
                                            errorlabel:
                                                'La contraseña no es valida',
                                            prefixicono: Icon(
                                              LineIcons.key,
                                              color: secundarycolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              MaskedInputFormater(
                                                  '(###) ###-####')
                                            ],
                                            keyboardType: TextInputType.phone,
                                            textDirection: TextDirection.ltr,
                                            autocorrect: true,
                                            controller: phoneInput,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: BorderSide(
                                                    color: secundarycolor,
                                                    width: 2),
                                              ),
                                              focusColor: contraste,
                                              hoverColor: primarycolor,
                                              fillColor: terciarycolor,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(
                                                    color: contraste),
                                              ),
                                              counterStyle: TextStyle(
                                                fontSize: 20,
                                                color: contraste,
                                              ),
                                              prefixIcon: Icon(
                                                LineIcons.mobilePhone,
                                                color: secundarycolor,
                                              ),
                                              labelText: "Numero telefonico",
                                              contentPadding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                            ),
                                            style: TextStyle(
                                              fontFamily: "SFSemibold",
                                              color: terciarycolor,
                                            ),
                                            // ignore: missing_return
                                            validator: (String valor) {
                                              if (valor.isEmpty) {
                                                return "numero telefonico no valido";
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          textbox(
                                            nombreInput: direccionInput,
                                            textlabel: "Domicilio actual",
                                            errorlabel:
                                                "La direccion no es valida",
                                            prefixicono: Icon(
                                              LineIcons.mapMarked,
                                              color: secundarycolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: size.width * 0.35,
                                                child: TextButton(
                                                  onPressed: () => getImage(),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Subir fotografia',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Icon(LineIcons.upload),
                                                    ],
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(primarycolor),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(contraste),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                  ),
                                                ),
                                              ),
                                              _images == null
                                                  ? const Text(
                                                      'No image selected.')
                                                  : Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          scale: 1,
                                                          image: FileImage(
                                                              _images),
                                                          fit: BoxFit.cover,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            status,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            onTap: () {
                                              // devolverá true si el formulario es válido, o falso si
                                              // el formulario no es válido.
                                              if (_formkeyRegiter.currentState
                                                  .validate()) {
                                                // Si el formulario es válido, queremos mostrar un Snackbar
                                                startUpload();
                                              }
                                            },
                                            child: errorregiter == false
                                                ? const ButtonForm(
                                                    txtbutton:
                                                        'Registrame ahora',
                                                    colorbtn: contraste,
                                                  )
                                                : const ButtonForm(
                                                    txtbutton:
                                                        'Tenemos problemas intentalo despues',
                                                    colorbtn: contraste,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: size.height,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "\"" + status + "\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaleFactor: 1.8,
                      ),
                      Text(
                        'Gracias por registrarse, vamos a trabajar..',
                        style: textsubtitlemini,
                        textScaleFactor: 1.6,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(contraste),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              nombre: nombreInput.text,
                              avatar:
                                  "http://192.168.0.4/lacondesa/php/ReProfilesimgs/" +
                                      nombreImageAvatar,
                            ),
                          ),
                        ),
                        child: Container(
                          width: size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Continuar',
                                style: texttitle,
                              ),
                              Icon(
                                LineIcons.arrowRight,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
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
