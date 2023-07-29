import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'qr_note_view.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:archive/archive.dart';

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
  List<QRNSection>? sections;

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

  void compressContent() {
    // var key = encrypt.Key.fromUtf8("NoTeQRC0De@9021KCK#VL#(Fd;evekc3");
    // var iv = encrypt.IV.fromUtf8("f#fCEefecw2vecdV");
    // var encr = encrypt.Encrypter(encrypt.AES(key));
    // return encr.encrypt(this.content, iv: iv).base64;
    var stringBytes = utf8.encode(this.content);
    var gzipBytes = GZipEncoder().encode(stringBytes);
    this.content = base64.encode(gzipBytes!);
  }

  String getCompressedContents() {
    this.compressContent();
    var result = this.content;
    this.unCompressContent();
    return result;
  }

  List<String> getRawParts({var oneTimeID = null}) {
    // Divide in equal parts after encoding
    List<String> qr_parts = [];
    var buffer_chars = getCompressedContents().split("");
    int counter = 0;
    String part_content = "";
    for (String i in buffer_chars) {
      part_content += i;
      counter += 1;
      if (counter >= 300) {
        qr_parts.add(part_content);
        counter = 0;
        part_content = "";
      }
    }

    // Add header to each part
    List<String> qr_parts_final = [];
    if (oneTimeID == null) oneTimeID = getRandomID();
    for (var i = 0; i < qr_parts.length; i++) {
      qr_parts_final.add("""#=> ${this.title}
#=> ${oneTimeID}/${i + 1}/${qr_parts.length}
${qr_parts[i]}""");
    }
    return qr_parts_final;
  }

  void unCompressContent() {
    var result = base64Decode(this.content);
    var gzipBytes = GZipDecoder().decodeBytes(result);
    this.content = utf8.decode(gzipBytes);
  }

  void buidSections() {
    List<QRNSection> result = [];
    RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
    List<String> lines = this.content.split(RegExp(r"\n+"));
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
    this.sections = result;
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

  String getRaw(){
    return """#=> ${this.title}
#=> ${this.type}/${this.key}
${this.content}""";
  }
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
//
// List<QRNSection> fromContentToSections(String qr_content) {
//   List<QRNSection> result = [];
//   RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
//   List<String> lines = qr_content.split(RegExp(r"\n+"));
//   bool waiting_for_meta = false;
//   String? title;
//   String? type;
//   String? key;
//   List<String> content = [];
//   for (String line in lines) {
//     if (exp.hasMatch(line) && waiting_for_meta == false) {
//       // i.e. First line of Header detected
//       // 1. Add previous stored QR Note (if any)
//       if (title != null && type != null && key != null) {
//         result.add(
//           QRNSection(
//               title: title, type: type, key: key, content: content.join("\n")),
//         );
//       }
//       // 2. Cleanup before processing
//       title = null;
//       type = null;
//       key = null;
//       content = [];
//       // 3. Store title, trigger for next header line
//       title = exp.firstMatch(line)![1].toString();
//       waiting_for_meta = true;
//     } else if (exp.hasMatch(line) && waiting_for_meta == true) {
//       // i.e. Second line of Header detected
//       // Store type and key type
//       String meta = exp.firstMatch(line)![1].toString();
//       List tokens = meta.split(RegExp(r"/"));
//       type = tokens[0];
//       key = tokens[1];
//       waiting_for_meta = false;
//     } else {
//       // i.e. Orinary line detected,
//       // Store to previous QR Note content
//       content.add(line);
//     }
//   }
//
//   // Add last one
//   if (title != null && type != null && key != null) {
//     result.add(
//       QRNSection(
//           title: title, type: type, key: key, content: content.join("\n")),
//     );
//   }
//   return result;
// }

String getRandomID(
    {chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890',
    id_length = 16}) {
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

  return getRandomString(id_length);
}
