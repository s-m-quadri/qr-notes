import 'package:flutter/material.dart';

import 'package:qr_notes/pagePlaceholder.dart';

class QRNHistory extends StatefulWidget {
  const QRNHistory({Key? key}) : super(key: key);

  @override
  State<QRNHistory> createState() => _QRNHistoryState();
}

class _QRNHistoryState extends State<QRNHistory> {
  @override
  Widget build(BuildContext context) {
    return RenderPlaceholder(icon: Icons.history, text: "History Page");
  }
}
