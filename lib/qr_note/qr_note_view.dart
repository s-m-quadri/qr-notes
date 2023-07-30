import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../storage/ds_qr_code.dart';
import '../storage/database_manager.dart';
import 'qr_code_raw.dart';
import 'render_pdf_view.dart';
import 'qr_code_edit_section.dart';
import 'qr_note_view_sections.dart';
import 'qr_note_view_meta.dart';

class QRNoteView extends StatefulWidget {
  const QRNoteView({Key? key, required this.qr_code}) : super(key: key);
  final QRCode qr_code;

  @override
  State<QRNoteView> createState() => _QRNoteViewState();
}

class _QRNoteViewState extends State<QRNoteView> {
  var _bottom_nav_cur_index = 0;

  void _bottomNavigationTap(var selected_value) {
    setState(() {
      _bottom_nav_cur_index = selected_value;
    });
  }

  void _saveCopy(BuildContext context, String title) {
    QRCode new_qr_code = QRCode(
        qrId: getRandomID(),
        title: title,
        content: widget.qr_code.getContentFromSections());
    DatabaseManager db = DatabaseManager();
    db.insertQRCode(data: new_qr_code);
    Navigator.pop(context);
  }

  AlertDialog _saveDialog(BuildContext context) {
    var _controller =
        TextEditingController(text: "Edit - ${widget.qr_code.title}");
    return AlertDialog(
      title: Text("Save as new copy!"),
      backgroundColor: Colors.blue.shade50,
      content: TextField(
        controller: _controller,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "cancel",
              style: TextStyle(color: Colors.red.shade700),
            )),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
            onPressed: () {
              _saveCopy(context, _controller.value.text);
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blue.shade700),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _optionWidget = [
      QRNoteViewMeta(qr_code: widget.qr_code),
      QRNoteViewSections(qr_code: widget.qr_code),
    ];

    List<BottomNavigationBarItem> _optionIcon = [
      BottomNavigationBarItem(
        icon: Icon(Icons.qr_code_scanner_outlined),
        label: "Meta",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.document_scanner_outlined),
        label: "Content",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qr_code.title),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save as new copy",
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade900,
        child: Icon(Icons.save_as_outlined),
        onPressed: () => showDialog(context: context, builder: _saveDialog),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue.shade700,
        type: BottomNavigationBarType.fixed,
        items: _optionIcon,
        onTap: _bottomNavigationTap,
        currentIndex: _bottom_nav_cur_index,
      ),
      body: Center(child: _optionWidget.elementAt(_bottom_nav_cur_index)),
    );
  }
}
