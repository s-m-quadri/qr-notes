import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../storage/ds_qr_code.dart';

Future<Uint8List> generatePDF(QRCode qr_code) async {
  var doc = pw.Document(
      theme: pw.ThemeData.withFont(
          base: pw.TtfFont(
              await rootBundle.load("assets/NovaSquare-Regular.ttf"))));
  var image = pw.MemoryImage(
    (await rootBundle.load("assets/icon.png")).buffer.asUint8List(),
  );
  String id = getRandomID();
  List<String> qr_codes = qr_code.getRawParts(oneTimeID: id);
  String title = qr_code.title;

  List<List<String>> pages = [];
  List<String> cur_page = [];
  var qr_count = 1;
  for (var code in qr_codes) {
    cur_page.add(code);
    qr_count++;
    if (qr_count > 20) {
      pages.add(cur_page);
      cur_page = [];
      qr_count = 1;
    }
  }
  if (qr_count != 1) {
    pages.add(cur_page);
  }

  for (var i = 0; i < pages.length; i++) {
    doc.addPage(pw.Page(
      build: (context) =>
          gridQRCode(context, image, title, id, pages[i], i + 1, pages.length),
      // pageFormat: PdfPageFormat.a4,
    ));
  }

  // var file = File("img/a.pdf");
  // await file.writeAsBytes(await doc.save());
  return doc.save();
  // await Printing.sharePdf(bytes: await doc.save(), filename: "sample.pdf");
}

pw.Widget gridQRCode(pw.Context context, pw.MemoryImage image, String title,
    String id, List<String> qr_codes, var page_no, var page_total) {
  List<pw.Widget> qr_codes_rendered = [];
  for (String i in qr_codes) {
    qr_codes_rendered.add(getRenderQRCode(data: i));
  }

  return pw.Column(children: [
    pw.Row(children: [
      pw.Image(image, width: 90, height: 90),
      pw.SizedBox(width: 20),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text("QR Notes | id: ${id} | page: ${page_no}/${page_total}",
            style: pw.TextStyle(
              color: PdfColor.fromHex("#000000"),
              fontSize: 16,
            )),
        pw.SizedBox(
          width: 350,
          child: pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColor.fromHex("#1c4587"),
              fontSize: 28,
            ),
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
            softWrap: true,
            textAlign: pw.TextAlign.left,
          ),
        ),
      ]),
    ]),
    pw.Divider(color: PdfColor.fromHex("#1c4587"), thickness: 1),
    pw.Wrap(children: qr_codes_rendered),
    pw.Divider(color: PdfColor.fromHex("#1c4587"), thickness: 1),
    pw.Text("Application: https://github.com/s-m-quadri/qr-notes",
        style: pw.TextStyle(
          color: PdfColor.fromHex("#000000"),
          fontSize: 12,
        )),
  ]);
}

pw.BarcodeWidget getRenderQRCode({required String data}) {
  return pw.BarcodeWidget(
    color: PdfColor.fromHex("#1c4587"),
    barcode: pw.Barcode.qrCode(),
    data: data,
    width: 100,
    height: 100,
    margin: const pw.EdgeInsets.all(9),
  );
}
