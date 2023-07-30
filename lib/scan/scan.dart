import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_notes/storage/ds_qr_code.dart';

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
        if (qr_code.partTotal != 1) {}
        qr_code.unCompressContent();
        qr_code.buildSections();
        db.insertQRCode(
          data: qr_code,
        );
        Navigator.pop(context);
        break;
      }
    }
  }

  Widget _statusWidget() {
    return _generateStatusWidget(
        title: "Progress",
        progress: null,
        color: Colors.yellow.shade700,
        icon: Icons.check_circle_outline);
    return ListTile(
      title: Text("Progress"),
      subtitle: LinearProgressIndicator(
        value: 0.2,
        backgroundColor: Colors.white,
        color: Colors.yellow.shade700,
        minHeight: 10,
      ),
      leading: Icon(Icons.check_circle_outline),
      iconColor: Colors.yellow.shade900,
      textColor: Colors.yellow.shade900,
      tileColor: Colors.blue.shade900,
    );
  }

  Widget _generateStatusWidget(
      {String title = "", var progress, var color, var icon}) {
    return ListTile(
      title: Text(title),
      subtitle: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.white,
        color: color,
        minHeight: 10,
      ),
      leading: Icon(icon),
      iconColor: color,
      textColor: color,
      tileColor: Colors.blue.shade900,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("QE Notes - Scanner"),
      ),
      body: Column(children: [
        ListTile(
          contentPadding: EdgeInsets.all(20),
          subtitle: Text(
            "Save QR Notes by pointing them!",
            style: TextStyle(fontSize: 42),
            textAlign: TextAlign.center,
          ),
          textColor: Colors.white,
          tileColor: Colors.blue.shade900,
        ),
        Expanded(
          child: MobileScanner(onDetect: _onDetect),
          // title: SizedBox(
          //   child: MobileScanner(onDetect: _onDetect),
          //   height: 400,
          // ),
        ),
        _statusWidget(),
      ]),
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
