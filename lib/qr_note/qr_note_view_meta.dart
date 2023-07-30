import 'package:flutter/material.dart';
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
  AlertDialog _onDeleteQRCode(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: const Text("Do you really want to Delete?"),
        content: const Text("Once deleted, the operation can't be undo."),
        actions: [
          TextButton(
              onPressed: () {
                _perform_deletion(context);
                Navigator.pop(context);
              },
              child: Text(
                "Delete Anyway!",
                style: TextStyle(color: Colors.red.shade700),
              )),
          TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Keep",
                style: TextStyle(color: Colors.blue.shade700),
              )),
        ]);
  }

  void _perform_deletion(BuildContext context) {
    DatabaseManager db = DatabaseManager();
    db.deleteQRCode(data: widget.qr_code);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Icon(Icons.qr_code_2_rounded,
              size: 300, color: Colors.blue.shade50),
          tileColor: Colors.blue.shade900,
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          title: const Text("Title"),
          subtitle:
              Text(widget.qr_code.title, style: const TextStyle(fontSize: 42)),
          tileColor: Colors.blue.shade900,
          textColor: Colors.white,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text("Identifier"),
          subtitle:
              Text(widget.qr_code.qrId, style: const TextStyle(fontSize: 22)),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text("Total Parts"),
          subtitle: Text("${widget.qr_code.partTotal}",
              style: const TextStyle(fontSize: 22)),
        ),
        ExpansionTile(
          title: const Text("Raw Content"),
          collapsedBackgroundColor: Colors.grey,
          collapsedTextColor: Colors.white,
          backgroundColor: Colors.blue.shade50,
          trailing: const Text("Show/Hide"),
          children: [
            ListTile(
              subtitle: Text(widget.qr_code.content),
            )
          ],
        ),
        // Divider(height: 1, color: Colors.blue.shade900),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text("Actions"),
          tileColor: Colors.blue.shade700,
          textColor: Colors.white,
        ),
        ListTile(
          title: const Text("Screen Render"),
          leading: const Icon(Icons.splitscreen_outlined),
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
          title: const Text("Render PDF"),
          leading: const Icon(Icons.picture_as_pdf),
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
          title: const Text("Delete QR Code"),
          leading: const Icon(Icons.delete_outline),
          iconColor: Colors.red.shade700,
          textColor: Colors.red.shade700,
          onTap: () => showDialog(
            context: context,
            builder: _onDeleteQRCode,
          ),
        ),
      ],
    );
  }
}
