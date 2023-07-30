import 'package:flutter/material.dart';

import 'database_manager.dart';
import 'ds_qr_code.dart';
import '../qr_note/qr_note_view.dart';

class QRNStorage extends StatefulWidget {
  const QRNStorage({Key? key}) : super(key: key);

  @override
  State<QRNStorage> createState() => _QRNStorageState();
}

class _QRNStorageState extends State<QRNStorage> {
  // For Preview in storage page
  Widget buildShortView(BuildContext context, QRCode qr_note) {
    return ListTile(
      horizontalTitleGap: 10,
      leading: Icon(Icons.qr_code_scanner,
          size: 50, color: Theme.of(context).primaryColorDark),
      iconColor: Theme.of(context).primaryColor,
      title: Text(qr_note.title),
      subtitle: Text(qr_note.qrId),
      trailing: const Text("Tap to View"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QRNoteView(qr_code: qr_note)));
      },
      splashColor: Theme.of(context).cardColor,
    );
  }

  // Query all the records from the database,
  // in the qr-code table for all qr-codes
  List<QRCode>? buckets;

  Future<Widget> getList() async {
    DatabaseManager db = DatabaseManager();
    List<QRCode>? buckets_temp = await db.getAllQRCodes();

    setState(() {
      buckets = buckets_temp;
    });

    if (buckets!.isEmpty) {
      return const Text("Scan to get QR Notes!");
    }

    return RefreshIndicator(
        child: ListView.builder(
          itemCount: buckets!.length,
          itemBuilder: (context, index) {
            return buildShortView(context, buckets![index]);
          },
        ),
        onRefresh: () async {
          List<QRCode>? buckets_temp = await db.getAllQRCodes();
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {
            buckets = buckets_temp;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      // Future Builder for Widget returning function:
      // getList is the function which requires time to load.
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
          return const Text("Error Occurred");
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
