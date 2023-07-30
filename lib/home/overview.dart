import 'package:flutter/material.dart';

class QRNOverview extends StatefulWidget {
  const QRNOverview({Key? key}) : super(key: key);

  @override
  State<QRNOverview> createState() => _QRNOverviewState();
}

class _QRNOverviewState extends State<QRNOverview> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/icon.png"),
            width: 128,
          ),
          SizedBox(height: 10),
          Text("Welcome to",
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColorDark,
              )),
          Text("QR Notes",
              style: TextStyle(
                fontSize: 48,
                color: Theme.of(context).primaryColorDark,
              )),
          SizedBox(
            child: Text(
              "Scan, Convert, Generate and Share Markdown-Notes via QR Codes",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark,
              ),
              textAlign: TextAlign.center,
            ),
            width: 256,
          ),
          SizedBox(
            child: Text(
              "v0.3/dev",
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).primaryColorDark,
              ),
              textAlign: TextAlign.center,
            ),
            width: 256,
          ),
          SizedBox(height: 10),
          Divider(thickness: 1, color: Theme.of(context).primaryColorDark),
          SizedBox(
            child: Text(
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColorDark,
              ),
              """Modules ready to use""",
              textAlign: TextAlign.center,
            ),
            width: 256,
          ),
          SizedBox(height: 10),
          SizedBox(
            child: Text(
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark,
              ),
              """
1. Storage Module: Managing the saved QR-Notes.
2. QR Notes Parser Module: Recognizing the QR-Code as QR-Note.
3. History Module: Storing the traces of all activities.
4. Scan Module: Detecting and processing the first QR-Note.""",
              textAlign: TextAlign.left,
            ),
            width: 256,
          ),
        ],
      ),
    );
  }
}
