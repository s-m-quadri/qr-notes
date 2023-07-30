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
  var _status_title = "Detecting";
  var _status_progress;
  var _status_color = Colors.red.shade700;
  var _status_icon = Icons.radio_button_checked;

  var _got_till_part_no = 0;
  QRCode? _result_qr_code;

  String result = "";
  DatabaseManager db = DatabaseManager();

  void updateResult(String data) {
    setState(() {
      result += "+++" + data;
    });
  }

  void _doneScan(QRCode qrCode){
    qrCode.unCompressContent();
    qrCode.buildSections();
    db.insertQRCode(data: qrCode,);
    Navigator.pop(context);
    dispose();
  }

  void _onDetect(capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        // Get valid QR_Note
        QRCode? qrCode = fromStringToQRCode(barcode.rawValue!);
        if (qrCode == null) continue;

        if (qrCode.partTotal != 1 && qrCode.partNo == _got_till_part_no + 1) {
          setState(() {
            if (_result_qr_code == null) _result_qr_code = qrCode;
            else _result_qr_code!.content += qrCode.content;
            _got_till_part_no++;
            if (_got_till_part_no == qrCode.partTotal){
              _status_title = "Done!";
              _status_color = Colors.green.shade900;
              _status_icon = Icons.check;
              _status_progress = _got_till_part_no / qrCode.partTotal;
              _doneScan(_result_qr_code!);
            } else {
              _status_title = "Progress (Looking for part ${_got_till_part_no + 1}).";
              _status_color = Colors.yellow.shade900;
              _status_icon = Icons.play_arrow_outlined;
              _status_progress = _got_till_part_no / qrCode.partTotal;
            }
          });
        }
        else if(_result_qr_code == null) _doneScan(qrCode);
      }
    }
  }

  Widget _statusWidget() {
    return _generateStatusWidget(
        title: _status_title,
        progress: _status_progress,
        color: _status_color,
        icon: _status_icon);
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
        title: const Text("QE Notes - Scanner"),
      ),
      body: Column(children: [
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          subtitle: const Text(
            "Save QR Notes by pointing them!",
            style: TextStyle(fontSize: 42),
            textAlign: TextAlign.center,
          ),
          textColor: Colors.white,
          tileColor: Colors.blue.shade900,
        ),
        Expanded(
          child: MobileScanner(onDetect: _onDetect),
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
        title: const Text("QR Notes - Scan - Results"),
      ),
      body: Center(
        child: Text(widget.result),
      ),
    );
  }
}
