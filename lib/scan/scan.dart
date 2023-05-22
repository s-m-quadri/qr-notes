import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_notes/storage/qr_code.dart';

import '../storage/database_manager.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String result = "";
  DatabaseManager db = DatabaseManager();

  void updateResult(String data) {
    setState(() {
      result += "+++" + data;
    });
  }

  void _onDetect(capture) {
    String sample_contents = """
    #=> This is Title
    #=> lCIECnCOj/1/1
    
    sample 000 text sample text sample text
    
    #=> This is subtitle-1
    #=> text/none
    111 sample text sample text sample text
    
    #=> This is subtitle-1
    #=> text/none
    222 sample text sample text sample text
    """;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      db.insertQRCode(
          data: QRCode(
              qrId: "abccc",
              title: "Sample",
              content: "Sample text Sample Text",
              partNo: 1,
              partTotal: 1));
      print("Inserted");
      Navigator.pop(context, barcode.rawValue);
      break;
      // updateResult(barcode.toString());
    }
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => QRScanPopup(result: result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QE Notes - Scanner"),
      ),
      body: Column(
        children: [
          Expanded(child: MobileScanner(onDetect: _onDetect)),
          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.done_outline_rounded),
                    label: Text("Done"),
                  ),
                  height: 50,
                ),
              ],
            ),
            height: 100,
          )
        ],
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
