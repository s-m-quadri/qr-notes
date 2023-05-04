import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String result = "";

  void updateResult(String data) {
    setState(() {
      result += "+++" + data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QE Notes - Scanner"),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            Navigator.pop(context, barcode.rawValue);
            break;
            // updateResult(barcode.toString());
          }
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => QRScanPopup(result: result)));
        },
      ),
    );
  }
}

class QRScanPopup extends StatefulWidget {
  const QRScanPopup({Key? key, required this.result}) : super(key: key);

  final String result;
  @override
  State<QRScanPopup> createState() => _QRScanPopupState();
}

class _QRScanPopupState extends State<QRScanPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Notes - Scan - Results"),
      ),
      body: Center(
        child: Text(widget.result),
      ),
    );
  }
}
