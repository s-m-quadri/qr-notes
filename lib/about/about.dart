import 'package:flutter/material.dart';

import 'package:qr_notes/pagePlaceholder.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Notes - About"),
      ),
      body: Center(
        child: RenderPlaceholder(icon: Icons.info_outline, text: "About Page"),
      ),
    );
  }
}
