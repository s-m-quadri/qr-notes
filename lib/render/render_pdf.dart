import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePDF() async{
  var doc = pw.Document();
  doc.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text("SSS"),
        ),
      )
  );

  // var file = File("img/a.pdf");
  // await file.writeAsBytes(await doc.save());
  // return doc.save();
  await Printing.sharePdf(bytes: await doc.save(), filename: "sample.pdf");
}


