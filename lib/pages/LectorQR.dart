import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class LectorQR extends StatefulWidget {
  @override
  _LectorQRState createState() => _LectorQRState();
}

class _LectorQRState extends State<LectorQR> {
  ScanResult _scanResult;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Lector códigos QR'),
      ),
      body: Center(
          child: _scanResult == null
              ? Text('Esperando datos de código')
              : Column(
                  children: [
                    Text('Contenido: ${_scanResult.rawContent}'),
                    Text('Formato: ${_scanResult.format.toString()}'),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          _scanCode();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _scanCode() async {
    var result = await BarcodeScanner.scan(
        options: ScanOptions(
            android: AndroidOptions(
      useAutoFocus: true,
    )));
    setState(() {
      _scanResult = result;
    });
  }
}
