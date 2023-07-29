import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class QRCodeEditSection extends StatefulWidget {
  const QRCodeEditSection({super.key, required this.text});
  final String text;
  @override
  State<QRCodeEditSection> createState() => _QRCodeEditSectionState();
}

class _QRCodeEditSectionState extends State<QRCodeEditSection> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: widget.text);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _controller.value.text);
          },
          child: Icon(Icons.done),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          tooltip: "Done!",
          splashColor: Colors.blue.shade100,
        ),
        appBar: AppBar(title: Text("Edit Section")),
        body: ListView(
          children: [
            SplittedMarkdownFormField(
              decoration: InputDecoration(
                hintText: 'Input',
                fillColor: Colors.blue.shade50,
                filled: true,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade700)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              emojiConvert: true,
              toolbarBackground: Colors.blue.shade100,
              cursorColor: Colors.blue.shade700,
              controller: _controller,
            )
          ],
        ));
  }
}
