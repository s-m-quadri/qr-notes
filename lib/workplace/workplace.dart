import 'package:flutter/material.dart';

import 'package:qr_notes/pagePlaceholder.dart';

class QRNWorkplace extends StatefulWidget {
  const QRNWorkplace({Key? key}) : super(key: key);

  @override
  State<QRNWorkplace> createState() => _QRNWorkplaceState();
}

class _QRNWorkplaceState extends State<QRNWorkplace> {
  @override
  Widget build(BuildContext context) {
    return RenderPlaceholder(
        icon: Icons.dashboard_customize_outlined, text: "Workpace Page");
  }
}
