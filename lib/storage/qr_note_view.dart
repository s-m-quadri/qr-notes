import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'qr_code.dart';
import '../storage/database_manager.dart';
import '../render/qr_code_raw.dart';
import '../render/render_pdf_view.dart';
import '../storage/qr_code_edit_section.dart';

class QRNoteView extends StatefulWidget {
  const QRNoteView({Key? key, required this.qr_code}) : super(key: key);
  final QRCode qr_code;

  @override
  State<QRNoteView> createState() => _QRNoteViewState();
}

class _QRNoteViewState extends State<QRNoteView> {
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
    return ListTile(
      horizontalTitleGap: 7,
      minVerticalPadding: 7,
      // leading: Icon(Icons.arrow_forward, size: 36, color: Colors.blue.shade700),
      title: Wrap(children: [
        SizedBox(height: 15),
        Icon(Icons.keyboard_arrow_down, size: 42, color: Colors.blue.shade700),
        Text(
          sections[index].title,
          style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              color: Colors.blue.shade700),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        // // Kind of message symbol
        // SizedBox(width: 10),
        // (sections[index].type == "text")
        //     ? (Icon(Icons.group))
        //     : (Icon(Icons.lock)),
      ]),

      subtitle: Column(
        children: [
          Wrap(children: [
            // Edit button
            SizedBox(width: 10),
            TextButton.icon(
                onPressed: () => _editSections(index: index),
                icon: Icon(Icons.mode_edit_outline_outlined),
                label: Text("Edit"),
                style: TextButton.styleFrom(
                    primary: Colors.blue.shade700,
                    backgroundColor: Colors.blue.shade50)),

            // Delete button
            SizedBox(width: 10),
            TextButton.icon(
              onPressed: () {
                _removeSections(index: index);
              },
              icon: Icon(Icons.delete_outline),
              label: Text("Delete"),
              style: TextButton.styleFrom(
                primary: Colors.red.shade700,
                backgroundColor: Colors.red.shade50,
              ),
            ),
          ]),
          MarkdownBody(data: sections[index].content),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      // subtitle: Text(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateSections();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qr_code.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.qr_code_2,
              size: 50,
              color: Theme.of(context).primaryColorLight,
            ),
            title: Text(widget.qr_code.title),
            subtitle: Text("id:" + widget.qr_code.qrId),
            tileColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            // trailing: IconButton(
            //   icon: Icon(
            //     Icons.delete_rounded,
            //     color: Colors.red[100],
            //     size: 30,
            //   ),
            //   onPressed: () {
            //     DatabaseManager db = DatabaseManager();
            //     db.deleteQRCode(data: widget.qr_code);
            //     Navigator.pop(context);
            //     dispose();
            //   },
            // ),
          ),
          Wrap(children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RenderQRCodeRaw(qr_code: widget.qr_code)));
              },
              icon: Icon(Icons.receipt_outlined),
              label: Text("Render Raw"),
              style: TextButton.styleFrom(
                primary: Colors.blue.shade900,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                DatabaseManager db = DatabaseManager();
                db.deleteQRCode(data: widget.qr_code);
                Navigator.pop(context);
                dispose();
              },
              icon: Icon(Icons.delete_rounded),
              label: Text("Delete QR Code"),
              style: TextButton.styleFrom(
                primary: Colors.red.shade900,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => renderPDFView(
                              qr_code: widget.qr_code,
                            )));
              },
              icon: Icon(Icons.picture_as_pdf_outlined),
              label: Text("Render PDF"),
              style: TextButton.styleFrom(
                primary: Colors.blue.shade900,
              ),
            ),
          ]),
          Expanded(
            child: ListView.builder(
              itemCount: sections.length,
              itemBuilder: buildSection,
            ),
          ),
        ],
      ),
    );
  }
}
