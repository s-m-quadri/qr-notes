import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../storage/ds_qr_code.dart';
import '../storage/database_manager.dart';
import 'qr_code_raw.dart';
import 'render_pdf_view.dart';
import 'qr_code_edit_section.dart';

class QRNoteViewSections extends StatefulWidget {
  const QRNoteViewSections({super.key, required this.qr_code});
  final QRCode qr_code;

  @override
  State<QRNoteViewSections> createState() => _QRNoteViewSectionsState();
}

class _QRNoteViewSectionsState extends State<QRNoteViewSections> {
  List<QRNSection> sections = [];
  List<QRNSection> mod_sections = [];

  void _updateSections({var index, var new_data = null}) {
    setState(() {
      if (widget.qr_code.sections == null) widget.qr_code.buidSections();
      sections = widget.qr_code.sections!;
      if (new_data != null) {
        widget.qr_code.sections![index].content = new_data;
      }
    });
  }

  void _addSection({required var index}) {
    setState(() {
      widget.qr_code.sections.insert(
          index + 1,
          QRNSection(
              title: "Untitled", content: "Empty", key: "none", type: "text"));
    });
  }

  void _removeSections({required var index}) {
    setState(() {
      widget.qr_code.sections!.removeAt(index);
    });
  }

  Future<void> _editSections({var index}) async {
    _updateSections(
        index: index,
        new_data: await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QRCodeEditSection(text: sections[index].content))));
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
              title: Text("Edit this section"),
              leading: Icon(Icons.mode_edit_outline_outlined),
              iconColor: Colors.blue.shade700,
              textColor: Colors.blue.shade700,
              onTap: () {
                _editSections(index: index);
              },
            ),
            ListTile(
              title: Text("Add new section (Before)"),
              leading: Icon(Icons.add),
              iconColor: Colors.blue.shade700,
              textColor: Colors.blue.shade700,
              onTap: () {
                _addSection(index: index);
              },
            ),
            ListTile(
              title: Text("Delete this section"),
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
          title: Text("ID: ${widget.qr_code.qrId}"),
          subtitle:
              Text("${widget.qr_code.title}", style: TextStyle(fontSize: 42)),
          tileColor: Colors.blue.shade900,
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
