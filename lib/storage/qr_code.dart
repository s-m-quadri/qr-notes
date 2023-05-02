import 'package:flutter/material.dart';

class QRCode {
  // Main Part of the class,
  // The data format for qr-notes:
  /****************************************************************************
   * DATA FORMAT:
   *    #=> qr_id/main_title
   *    ... 1 or more sections
   ****************************************************************************
   * SECTION FORMAT:
   *    #=> type_id/key_id/section_title
   *    ... data (in markdown)
   ***************************************************************************/
  QRCode(
      {this.type = "raw",
        required this.title,
        required this.content,
        this.isEncrypted = false});

  String type;
  String title;
  String content;
  bool isEncrypted;

  // For database, column to data unit match
  Map<String, dynamic> mapToDB() {
    return {
      "title": title,
      "content": content,
      "isEncrypted": isEncrypted ? 1 : 0,
    };
  }

  // For Preview in storage page
  Widget buildShortView(BuildContext context) {
    switch (type) {
      case "raw":
        return ListTile(
          horizontalTitleGap: 5,
          leading: Icon(Icons.document_scanner_outlined),
          iconColor: Theme.of(context).primaryColor,
          title: Text(this.title),
          subtitle: Text(this.type),
          trailing: Icon(Icons.share),
        );

      default:
        return Center(
          child: Text("Not recognized"),
        );
    }
  }
}