import 'package:flutter/material.dart';
import '../pagePlaceholder.dart';

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

          // Place Holder
          SizedBox(height: 10),
          Divider(thickness: 1, color: Theme.of(context).primaryColorDark),
          RenderPlaceholder(icon: Icons.home_outlined, text: "Home Page")
        ],
      ),
    );
  }
}
