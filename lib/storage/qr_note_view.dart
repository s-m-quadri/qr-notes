import 'package:flutter/material.dart';
import 'qr_code.dart';
import '../storage/database_manager.dart';

class QRNoteView extends StatefulWidget {
  const QRNoteView({Key? key, required this.qr_code}) : super(key: key);
  final QRCode qr_code;

  @override
  State<QRNoteView> createState() => _QRNoteViewState();
}

class _QRNoteViewState extends State<QRNoteView> {
  List<QRNSection> sections = [];

  void _updateSections() {
    setState(() {
      sections = fromContentToSections(widget.qr_code.content);
      // print(sections[1].content);
    });
  }

  Widget buildSection(BuildContext context, int index) {
    return ListTile(
      horizontalTitleGap: 5,
      minVerticalPadding: 10,
      leading: Icon(Icons.mail_outline_sharp, size: 30),
      iconColor: Theme.of(context).primaryColor,
      title: Row(children: [
        Text(sections[index].title),
        SizedBox(width: 10),
        (sections[index].type == "text")
            ? (Icon(Icons.group))
            : (Icon(Icons.lock)),
      ]),
      subtitle: Text(sections[index].content),
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
        children: [
          ListTile(
            trailing: IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: Colors.red[100],
                size: 30,
              ),
              onPressed: () {
                DatabaseManager db = DatabaseManager();
                db.deleteQRCode(data: widget.qr_code);
                Navigator.pop(context);
                dispose();
              },
            ),
            leading: Icon(
              Icons.qr_code_2,
              size: 50,
              color: Theme.of(context).primaryColorLight,
            ),
            title: Text(widget.qr_code.title),
            subtitle: Text("id:" + widget.qr_code.qrId),
            tileColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
          ),
          SizedBox(height: 15),
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
