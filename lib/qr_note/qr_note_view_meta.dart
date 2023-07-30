import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:qr_notes/storage/ds_qr_code.dart';
import 'qr_code_raw.dart';
import '../storage/database_manager.dart';
import 'render_pdf_view.dart';

class QRNoteViewMeta extends StatefulWidget {
  const QRNoteViewMeta({super.key, required this.qr_code});
  final QRCode qr_code;
  @override
  State<QRNoteViewMeta> createState() => _QRNoteViewMetaState();
}

class _QRNoteViewMetaState extends State<QRNoteViewMeta> {
  bool _delete = false;

  AlertDialog _onDeleteQRCode(BuildContext context) {
    return AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: Text("Do you really want to Delete?"),
          content: Text("Once deleted, the operation can't be undo."),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _delete = true;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete Anyway!",
                  style: TextStyle(color: Colors.red.shade700),
                )),
            TextButton(
                style:
                    TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Keep",
                  style: TextStyle(color: Colors.blue.shade700),
                )),
          ]);
  }

  void _perform_deletion(BuildContext context){
    DatabaseManager db = DatabaseManager();
    db.deleteQRCode(data: widget.qr_code);
    Navigator.pop(context);
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._delete) (_perform_deletion(context));
    return ListView(
      children: [
        Icon(Icons.qr_code_2_sharp, size: 300, color: Colors.blue.shade700),
        ListTile(
          contentPadding: EdgeInsets.all(20),
          title: Text("Title"),
          subtitle:
              Text("${widget.qr_code.title}", style: TextStyle(fontSize: 42)),
          tileColor: Colors.blue.shade900,
          textColor: Colors.white,
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text("Identifier"),
          subtitle:
              Text("${widget.qr_code.qrId}", style: TextStyle(fontSize: 36)),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text("Total Parts"),
          subtitle: Text("${widget.qr_code.partTotal}",
              style: TextStyle(fontSize: 36)),
        ),
        Divider(height: 1, color: Colors.blue.shade900),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text("Actions"),
          tileColor: Colors.blue.shade700,
          textColor: Colors.white,
        ),
        ListTile(
          title: Text("Render Raw"),
          leading: Icon(Icons.receipt_outlined),
          iconColor: Colors.blue.shade700,
          textColor: Colors.blue.shade700,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RenderQRCodeRaw(qr_code: widget.qr_code)));
          },
        ),
        ListTile(
          title: Text("Render PDF"),
          leading: Icon(Icons.picture_as_pdf_outlined),
          iconColor: Colors.blue.shade700,
          textColor: Colors.blue.shade700,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => renderPDFView(
                          qr_code: widget.qr_code,
                        )));
          },
        ),
        ListTile(
          title: Text("Delete QR Code"),
          leading: Icon(Icons.delete_rounded),
          iconColor: Colors.red.shade700,
          textColor: Colors.red.shade700,
          onTap: () => showDialog(context: context, builder: _onDeleteQRCode,),
        ),
        ExpansionTile(
          title: Text("Contents"),
          leading: Icon(Icons.dock),
          collapsedIconColor: Colors.white,
          collapsedBackgroundColor: Colors.blue.shade700,
          collapsedTextColor: Colors.white,
          backgroundColor: Colors.blue.shade50,
          trailing: Text("Show/Hide"),
          children: [
            ListTile(
              subtitle: Text(widget.qr_code.content),
            )
          ],
        ),
      ],
    );
  }
}
