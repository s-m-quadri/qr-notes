import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QRNOverview extends StatefulWidget {
  const QRNOverview({Key? key}) : super(key: key);

  @override
  State<QRNOverview> createState() => _QRNOverviewState();
}

class _QRNOverviewState extends State<QRNOverview> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Image(
          image: AssetImage("assets/icon.png"),
          width: 300,
          height: 300,
        ),
        ListTile(
          title: Text(
            "Welcome to",
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).primaryColorDark,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            "QR Notes",
            style: TextStyle(
              fontSize: 48,
              color: Theme.of(context).primaryColorDark,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          tileColor: Colors.blue.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          title: Text(
            "Scan, Convert, Generate and Share Markdown-Notes via QR Codes",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColorDark,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: TextButton(
            onPressed: () => launchUrl(
                Uri.parse("https://github.com/s-m-quadri/qr-notes/releases")),
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade900),
            child: const Text("What's New!"),
          ),
        ),
      ],
    );
  }
}
