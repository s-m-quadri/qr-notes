import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:encrypt/encrypt.dart';
import '../storage/qr_code.dart';

class RenderQRCodeRaw extends StatefulWidget {
  const RenderQRCodeRaw({super.key, required this.qr_code});
  // final String raw_text;
  final QRCode qr_code;
  @override
  State<RenderQRCodeRaw> createState() => _RenderQRCodeRawState();
}

class _RenderQRCodeRawState extends State<RenderQRCodeRaw> {
  List<String> qr_parts = [];
  String oneTimeID = getRandomID();

  void divideIntoParts() {
    var buffer_chars = widget.qr_code.getCompressedContents().split("");
    int counter = 0;
    String part_content = "";
    for (String i in buffer_chars) {
      part_content += i;
      counter += 1;
      if (counter >= 300) {
        this.qr_parts.add(part_content);
        counter = 0;
        part_content = "";
      }
    }
  }

  Widget _itemBuilder_qr_code(BuildContext context, int index) {
    String qr_content_raw = """#=> ${widget.qr_code.title}
#=> ${this.oneTimeID}/${index + 1}/${this.qr_parts.length}
${this.qr_parts[index]}""";
    return ListTile(
      horizontalTitleGap: 7,
      minVerticalPadding: 7,
      title: Text(widget.qr_code.title),
      subtitle: Column(children: [
        Text(qr_content_raw),
        QrImage(data: qr_content_raw, gapless: false)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    divideIntoParts();
    return Scaffold(
      appBar: AppBar(title: Text("Rendered")),
      body: ListView.builder(
          itemBuilder: _itemBuilder_qr_code, itemCount: this.qr_parts.length),
      // body: ListView(
      //   children: [
      //     ListTile(
      //       horizontalTitleGap: 7,
      //       minVerticalPadding: 7,
      //       title: Text(widget.qr_code.title),
      //       subtitle: Text(widget.qr_code.getCompressedContents()),
      //     ),
      //     QrImage(data: widget.qr_code.getCompressedContents(), gapless: false)
      //   ],
      // ),
    );
  }
}
