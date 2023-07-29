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
    #=> lCIECnCOj/2/2
    
    sample 000 text sample text sample text
    
    #=> This is subtitle-1
    #=> text/none
    111 sample text sample text sample text
    
    #=> This is subtitle-1
    #=> text/none
    222 sample text sample text sample text
    """;
    final List<Barcode> barcodes = capture.barcodes;
    QRCode? test_qr = fromStringToQRCode(sample_contents);
    QRCode default_qr = QRCode(
        qrId: "abccc",
        title: "Sample",
        content: "Sample text Sample Text",
        partNo: 1,
        partTotal: 1);
    for (final barcode in barcodes) {
      if (barcode.rawValue == null) {
        continue;
      } else {
        QRCode? qr_code = fromStringToQRCode(barcode.rawValue!);
        if (qr_code == null) {
          continue;
        }
        qr_code.unCompressContent();
        qr_code.buidSections();
        db.insertQRCode(
          data: qr_code,
        );
        Navigator.pop(context);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("QE Notes - Scanner"),
      ),
      body: Column(children: [
        Text("Save QR Notes by pointing them!",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        SizedBox(height: 10),
        Center(
          child: SizedBox(
            child: MobileScanner(onDetect: _onDetect),
            width: 400,
            height: 400,
          ),
        ),
        SizedBox(
          child: Column(
            children: [
              SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  label: Text("Cancel"),
                ),
                height: 50,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          height: 100,
        )
      ], mainAxisAlignment: MainAxisAlignment.center),
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
