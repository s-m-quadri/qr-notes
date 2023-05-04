import 'package:flutter/material.dart';

import 'package:qr_notes/pagePlaceholder.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Notes - Settings"),
      ),
      body: Center(
        child:
            RenderPlaceholder(icon: Icons.settings, text: "Settings Page"),
      ),
    );
  }
}
