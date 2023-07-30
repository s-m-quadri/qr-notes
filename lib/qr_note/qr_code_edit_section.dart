import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class QRCodeEditSection extends StatefulWidget {
  const QRCodeEditSection(
      {super.key, required this.text, this.simple_edit = false});
  final String text;
  final bool simple_edit;
  @override
  State<QRCodeEditSection> createState() => _QRCodeEditSectionState();
}

class _QRCodeEditSectionState extends State<QRCodeEditSection> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: widget.text);

    return Scaffold(
        backgroundColor: Colors.yellow.shade50,
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
        appBar: AppBar(title: Text("Edit Text")),
        body: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(20),
              subtitle: Text(
                  "${(widget.simple_edit) ? ('Edit') : ('Markdown Edit')}",
                  style: TextStyle(fontSize: 42)),
              tileColor: Colors.blue.shade700,
              textColor: Colors.white,
            ),
            (widget.simple_edit)
                ? (Placeholder())
                : (SplittedMarkdownFormField(
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
                  ))
          ],
        ));
  }
}
