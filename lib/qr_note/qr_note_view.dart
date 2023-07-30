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
