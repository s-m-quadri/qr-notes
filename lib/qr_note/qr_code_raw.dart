import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../storage/ds_qr_code.dart';

class RenderQRCodeRaw extends StatefulWidget {
  const RenderQRCodeRaw({super.key, required this.qr_code});
  final QRCode qr_code;
  @override
  State<RenderQRCodeRaw> createState() => _RenderQRCodeRawState();
}

class _RenderQRCodeRawState extends State<RenderQRCodeRaw> {
  String oneTimeID = getRandomID();
  List<String> qr_parts = [];

  void refreshParts() {
    qr_parts = widget.qr_code.getRawParts();
  }

  Widget _itemBuilder_qr_code(BuildContext context, int index) {
    return ExpansionTile(
        title: Text("Id ${widget.qr_code.qrId} | Part ${index + 1}"),
        trailing: const Text(""),
        backgroundColor: Colors.blue.shade50,
        subtitle: QrImageView(data: qr_parts[index], gapless: false),
        children: [Text(qr_parts[index])],
    );
  }

  @override
  Widget build(BuildContext context) {
    refreshParts();
    return Scaffold(
      appBar: AppBar(title: const Text("Rendered")),
      body: ListView.builder(
          itemBuilder: _itemBuilder_qr_code, itemCount: qr_parts.length),
    );
  }
}
