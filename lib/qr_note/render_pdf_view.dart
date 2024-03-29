import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../qr_note/render_pdf.dart';
import '../storage/ds_qr_code.dart';

class renderPDFView extends StatefulWidget {
  const renderPDFView({super.key, required this.qr_code});
  final QRCode qr_code;
  @override
  State<renderPDFView> createState() => _renderPDFViewState();
}

class _renderPDFViewState extends State<renderPDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF View")),
      body: PdfPreview(
        build: (format) => generatePDF(widget.qr_code),
        canChangeOrientation: false,
        canDebug: false,
        pageFormats: Map.from({"Default ISO A4": PdfPageFormat.a4}),
        pdfFileName: "${widget.qr_code.title} (${widget.qr_code.qrId})",
      ),
    );
  }
}
