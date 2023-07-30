import 'package:flutter/material.dart';
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
    TextEditingController controller =
        TextEditingController(text: widget.text);

    return Scaffold(
        backgroundColor: Colors.yellow.shade50,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, controller.value.text);
          },
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          tooltip: "Done!",
          splashColor: Colors.blue.shade100,
          child: const Icon(Icons.done),
        ),
        appBar: AppBar(title: const Text("Edit Text")),
        body: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(20),
              subtitle: const Text("Edit Section", style: TextStyle(fontSize: 42)),
              tileColor: Colors.blue.shade700,
              textColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MarkdownAutoPreview(
                decoration: InputDecoration(
                  hintText: 'Input',
                  fillColor: Colors.blue.shade50,
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
                emojiConvert: true,
                toolbarBackground: Colors.blue.shade100,
                cursorColor: Colors.blue.shade700,
                controller: controller,
              ),
            ),
          ],
        ));
  }
}
