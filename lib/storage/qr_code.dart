import 'package:flutter/material.dart';
import 'qr_note_view.dart';

class QRCode {
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
  Map<String, dynamic> mapToDB() {
    return {
      "qr_id": qrId,
      "part_no": partNo,
      "part_total": partTotal,
      "qr_title": title,
      "qr_content": content,
    };
  }
}

class QRNSection {
  QRNSection({
    required this.title,
    required this.type,
    required this.key,
    required this.content,
  });

  String title;
  String type;
  String key;
  String content;
}

QRCode? fromStringToQRCode(String input) {
  RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
  List<String> lines = input.split(RegExp(r"\n+"));
  print(lines);
  if (exp.hasMatch(lines[0]) && exp.hasMatch(lines[1])) {
    String qr_title = exp.firstMatch(lines[0])![1].toString();
    String qr_meta = exp.firstMatch(lines[1])![1].toString();
    List<String> qr_metas = qr_meta.split(RegExp(r"/"));
    String qr_id = qr_metas[0].toString();
    int qr_part_no = int.parse(qr_metas[1].toString());
    int qr_part_total = int.parse(qr_metas[2].toString());
    lines.removeRange(0, 2);
    String qr_content = lines.join("\n");
    return QRCode(
        qrId: qr_id,
        title: qr_title,
        content: qr_content,
        partNo: qr_part_no,
        partTotal: qr_part_total);
  }
}

List<QRNSection> fromContentToSections(String qr_content) {
  List<QRNSection> result = [];
  RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
  List<String> lines = qr_content.split(RegExp(r"\n+"));
  bool waiting_for_meta = false;
  String? title;
  String? type;
  String? key;
  List<String> content = [];
  for (String line in lines) {
    if (exp.hasMatch(line) && waiting_for_meta == false) {
      // i.e. First line of Header detected
      // 1. Add previous stored QR Note (if any)
      if (title != null && type != null && key != null) {
        result.add(
          QRNSection(
              title: title, type: type, key: key, content: content.join("\n")),
        );
      }
      // 2. Cleanup before processing
      title = null;
      type = null;
      key = null;
      content = [];
      // 3. Store title, trigger for next header line
      title = exp.firstMatch(line)![1].toString();
      waiting_for_meta = true;
    } else if (exp.hasMatch(line) && waiting_for_meta == true) {
      // i.e. Second line of Header detected
      // Store type and key type
      String meta = exp.firstMatch(line)![1].toString();
      List tokens = meta.split(RegExp(r"/"));
      type = tokens[0];
      key = tokens[1];
      waiting_for_meta = false;
    } else {
      // i.e. Orinary line detected,
      // Store to previous QR Note content
      content.add(line);
    }
  }

  // Add last one
  if (title != null && type != null && key != null) {
    result.add(
      QRNSection(
          title: title, type: type, key: key, content: content.join("\n")),
    );
  }
  return result;
}
