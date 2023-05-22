import 'package:flutter/material.dart';

import 'database_manager.dart';
import 'qr_code.dart';

class QRNStorage extends StatefulWidget {
  const QRNStorage({Key? key}) : super(key: key);

  @override
  State<QRNStorage> createState() => _QRNStorageState();
}

class _QRNStorageState extends State<QRNStorage> {
  // Query all the records from the database,
  // in the qr-code table for all qr-codes
  // Abstraction, most of the work is done by
  // 1. Database Management (Dart File)
  // 2. QR Code (Dart File)
  // List<QRCode>? buckets;
  List<QRCode>? buckets;
  Future<Widget> getList() async {
    DatabaseManager db = DatabaseManager();
    buckets = await db.getAllQRCodes();
    return ListView.builder(
      itemCount: buckets!.length,
      itemBuilder: (context, index) {
        return buckets![index].buildShortView(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      // Future Builder for Widget returning funtion:
      // getList is the funtion which requires time to load.
      // Thus, builder function varies based on the status of it.
      future: getList(),

      // Builder function runs each time the snapshot changes,
      // snapshot is just the output of getList, at given time.
      // It runs at:
      // 1. Initialization,
      // 2. Success/Failure of snapshot
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text("Error Occurred");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
