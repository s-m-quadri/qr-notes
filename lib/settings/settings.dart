import 'package:flutter/material.dart';
import '../storage/database_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    DatabaseManager db = DatabaseManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Notes - Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Clear History"),
            subtitle: const Text("Delete All the records"),
            onTap: () => db.deleteAllTraces(),
            splashColor: Colors.blue.shade50,
            leading: const Icon(Icons.cleaning_services_outlined),
            iconColor: Colors.blue.shade700,
          ),
          ListTile(
            title: const Text("Clear Storage"),
            subtitle: const Text("Delete All the QR Codes"),
            onTap: () => db.deleteAllQRCodes(),
            splashColor: Colors.blue.shade50,
            leading: const Icon(Icons.cleaning_services_outlined),
            iconColor: Colors.red.shade700,
          ),
        ],
      ),
    );
  }
}
