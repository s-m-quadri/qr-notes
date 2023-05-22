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
  QRCode({
    required this.qrId,
    required this.title,
    required this.content,
    this.partNo = 1,
    this.partTotal = 1,
  });

  String qrId;
  int partNo;
  int partTotal;
  String title;
  String content;

  // For database, column to data unit match
  Map<String, dynamic> mapQRCode() {
    return {
      "qr_id": qrId,
      "part_no": partNo,
      "part_total": partTotal,
      "qr_title": title,
      "qr_content": content,
    };
  }

  // For Preview in storage page
  Widget buildShortView(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5,
      leading: Icon(Icons.document_scanner_outlined),
      iconColor: Theme.of(context).primaryColor,
      title: Text(this.title),
      subtitle: Text(this.qrId),
      trailing: Icon(Icons.share),
    );
  }
  
  void fromStringToQRCode(String input){
    RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
    // List<String> lines = input.split(RegExp(r"\n*"));
    // for (final line in lines){
    //   special_lines.hasMatch(line)
    // }
    // input.startsWith("#=>");
    Iterable<RegExpMatch> matches = exp.allMatches(input);
    for (final m in matches) {
      print(m[0]);
    }
  }
}
