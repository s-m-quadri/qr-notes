import 'dart:convert';
import 'dart:math';
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

  // Build Sections
  List<QRNSection> sections = [];
  void buildSections() {
    List<QRNSection> result = [];
    RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
    List<String> lines = this.content.split(RegExp(r"\n+"));
    bool waitingForMeta = false;
    String? title;
    String? type;
    String? key;
    List<String> content = [];

    for (String line in lines) {
      if (exp.hasMatch(line) && waitingForMeta == false) {
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
        waitingForMeta = true;
      } else if (exp.hasMatch(line) && waitingForMeta == true) {
        // i.e. Second line of Header detected
        // Store type and key type
        String meta = exp.firstMatch(line)![1].toString();
        List tokens = meta.split(RegExp(r"/"));
        type = tokens[0];
        key = tokens[1];
        waitingForMeta = false;
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
    sections = result;
  }
  String getContentFromSections(){
    String rawContent = "";
    for (var section in sections){
      rawContent = "$rawContent\n${section.getRaw()}";
    }
    return rawContent;
  }

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

  // Compress Uncompress Contents
  void compressContent() {
    // var key = encrypt.Key.fromUtf8("NoTeQRC0De@9021KCK#VL#(Fd;evekc3");
    // var iv = encrypt.IV.fromUtf8("f#fCEefecw2vecdV");
    // var encr = encrypt.Encrypter(encrypt.AES(key));
    // return encr.encrypt(this.content, iv: iv).base64;
    var stringBytes = utf8.encode(content);
    var gzipBytes = GZipEncoder().encode(stringBytes);
    content = base64.encode(gzipBytes!);
  }
  void unCompressContent() {
    var result = base64Decode(content);
    var gzipBytes = GZipDecoder().decodeBytes(result);
    content = utf8.decode(gzipBytes);
  }
  String getCompressedContents() {
    compressContent();
    var result = content;
    unCompressContent();
    return result;
  }

  // Raw QR Notes
  List<String> getRawParts({var oneTimeID}) {
    // Divide in equal parts after encoding
    List<String> qrParts = [];
    var bufferChars = getCompressedContents().split("");
    int counter = 0;
    String partContent = "";
    for (String i in bufferChars) {
      partContent += i;
      counter += 1;
      if (counter >= 300) {
        qrParts.add(partContent);
        counter = 0;
        partContent = "";
      }
    }

    // Add header to each part
    List<String> qrPartsFinal = [];
    oneTimeID ??= getRandomID();
    for (var i = 0; i < qrParts.length; i++) {
      qrPartsFinal.add("""#=> $title
#=> $oneTimeID/${i + 1}/${qrParts.length}
${qrParts[i]}""");
    }
    return qrPartsFinal;
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
    return """#=> $title
#=> $type/$key
$content""";
  }
}

QRCode? fromStringToQRCode(String input) {
  RegExp exp = RegExp(r"^(?:\s)*#=>(?:\s)*([^\n]*)");
  List<String> lines = input.split(RegExp(r"\n+"));
  if (exp.hasMatch(lines[0]) && exp.hasMatch(lines[1])) {
    String qrTitle = exp.firstMatch(lines[0])![1].toString();
    String qrMeta = exp.firstMatch(lines[1])![1].toString();
    List<String> qrMetas = qrMeta.split(RegExp(r"/"));
    String qrId = qrMetas[0].toString();
    int qrPartNo = int.parse(qrMetas[1].toString());
    int qrPartTotal = int.parse(qrMetas[2].toString());
    lines.removeRange(0, 2);
    String qrContent = lines.join("\n");
    return QRCode(
        qrId: qrId,
        title: qrTitle,
        content: qrContent,
        partNo: qrPartNo,
        partTotal: qrPartTotal);
  }
  return null;
}

String getRandomID(
    {chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890',
    id_length = 16}) {
  Random rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return getRandomString(id_length);
}
