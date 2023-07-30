import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:encrypt/encrypt.dart';
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
    return ListTile(
      horizontalTitleGap: 7,
      minVerticalPadding: 7,
      title: Text(widget.qr_code.title),
      subtitle: Column(children: [
        Text(this.qr_parts[index]),
        QrImageView(data: this.qr_parts[index], gapless: false)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    refreshParts();
    return Scaffold(
      appBar: AppBar(title: Text("Rendered")),
      body: ListView.builder(
          itemBuilder: _itemBuilder_qr_code, itemCount: this.qr_parts.length),
    );
  }
}
