import 'package:flutter/material.dart';

import 'package:qr_notes/pagePlaceholder.dart';

class QRNSecretes extends StatefulWidget {
  const QRNSecretes({Key? key}) : super(key: key);

  @override
  State<QRNSecretes> createState() => _QRNSecretesState();
}

class _QRNSecretesState extends State<QRNSecretes> {
  @override
  Widget build(BuildContext context) {
    return RenderPlaceholder(icon: Icons.lock_outline, text: "Secretes Page");
  }
}
