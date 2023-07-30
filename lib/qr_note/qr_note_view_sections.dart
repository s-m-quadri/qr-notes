import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../storage/ds_qr_code.dart';
import '../storage/database_manager.dart';
import 'qr_code_raw.dart';
import 'render_pdf_view.dart';
import 'qr_code_edit_section.dart';
import '../storage/database_manager.dart';

class QRNoteViewSections extends StatefulWidget {
  const QRNoteViewSections({super.key, required this.qr_code});
  final QRCode qr_code;

  @override
  State<QRNoteViewSections> createState() => _QRNoteViewSectionsState();
}

class _QRNoteViewSectionsState extends State<QRNoteViewSections> {
  bool is_modified = false;
  List<QRNSection> sections = [];
  List<QRNSection> mod_sections = [];
  bool _save_operation = false;
  String _save_title = "";

  void _updateSections({var index, var new_data = null, String title = ""}) {
    setState(() {
      if (widget.qr_code.sections.isEmpty) widget.qr_code.buildSections();
      sections = widget.qr_code.sections;
      if (new_data != null) {
        is_modified = true;
        widget.qr_code.sections![index].content = new_data;
      }
    });
  }

  void _updateTitle(BuildContext context, String title, var index) {
    setState(() {
      widget.qr_code.sections![index].title = title;
    });
    // Navigator.pop(context);
  }

  AlertDialog _editTitleDialog(BuildContext context, var index) {
    var _controller1 =
        TextEditingController(text: "${widget.qr_code.sections[index].title}");
    return AlertDialog(
      title: Text("Edit Section - Title"),
      backgroundColor: Colors.blue.shade50,
      content: TextField(
        controller: _controller1,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red.shade700),
            )),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
            onPressed: () {
              _updateTitle(context, _controller1.value.text, index);
              Navigator.pop(context);
              _editSections(index: index);
            },
            child: Text(
              "Proceed",
              style: TextStyle(color: Colors.blue.shade700),
            )),
      ],
    );
  }

  void _duplicateSection({required var index}) {
    setState(() {
      is_modified = true;
      widget.qr_code.sections.insert(index + 1, widget.qr_code.sections[index]);
    });
  }

  void _removeSections({required var index}) {
    setState(() {
      is_modified = true;
      widget.qr_code.sections.removeAt(index);
    });
  }

  Future<void> _editSections({var index}) async {
    var new_data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QRCodeEditSection(text: sections[index].content)));
    _updateSections(index: index, new_data: new_data);
  }

  Widget buildSection(BuildContext context, int index) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "${index + 1}. ${sections[index].title}",
        style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w300,
            color: Colors.blue.shade700),
      ),
      children: [
        ExpansionTile(
          backgroundColor: Colors.blue.shade50,
          trailing: Text(""),
          title: MarkdownBody(data: sections[index].content),
          children: [
            ListTile(
              title: Text("Edit Section"),
              leading: Icon(Icons.mode_edit_outline_outlined),
              iconColor: Colors.blue.shade700,
              textColor: Colors.blue.shade700,
              onTap: () => showDialog(
                context: context,
                builder: (context) => _editTitleDialog(context, index),
              ),
            ),
            ListTile(
              title: Text("Duplicate Section"),
              leading: Icon(Icons.add_box_outlined),
              iconColor: Colors.blue.shade700,
              textColor: Colors.blue.shade700,
              onTap: () {
                _duplicateSection(index: index);
              },
            ),
            ListTile(
              title: Text("Delete this Section"),
              leading: Icon(Icons.delete_outline),
              iconColor: Colors.red.shade700,
              textColor: Colors.red.shade700,
              onTap: () {
                _removeSections(index: index);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateSections();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(20),
          title: Text(
              "ID: ${widget.qr_code.qrId} | ${is_modified ? 'Not Saved' : 'Saved'}"),
          subtitle:
              Text("${widget.qr_code.title}", style: TextStyle(fontSize: 42)),
          tileColor:
              is_modified ? Colors.yellow.shade900 : Colors.blue.shade900,
          textColor: Colors.white,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sections.length,
            itemBuilder: buildSection,
          ),
        ),
      ],
    );
  }
}
