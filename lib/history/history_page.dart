import 'package:flutter/material.dart';

import 'package:qr_notes/storage/ds_trace.dart';
import '../storage/database_manager.dart';

class QRNHistory extends StatefulWidget {
  const QRNHistory({Key? key}) : super(key: key);

  @override
  State<QRNHistory> createState() => _QRNHistoryState();
}

class _QRNHistoryState extends State<QRNHistory> {
  // For Preview in storage page
  Widget buildShortView(BuildContext context, Trace trace) {
    return ListTile(
      horizontalTitleGap: 5,
      leading: const Icon(Icons.history),
      iconColor: Theme.of(context).primaryColor,
      title: Text(trace.datetime.toString()),
      subtitle: Text(trace.activity),
    );
  }

  // Query all the records from the database,
  // in the qr-code table for all qr-codes
  List<Trace>? buckets;

  Future<Widget> getList() async {
    DatabaseManager db = DatabaseManager();
    List<Trace>? bucketsTemp = await db.getAllHistory();

    setState(() {
      buckets = bucketsTemp;
    });

    if (buckets!.isEmpty) {
      return const Text("Do some activity to trace history!");
    }

    return RefreshIndicator(
        child: ListView.builder(
          itemCount: buckets!.length,
          itemBuilder: (context, index) {
            return buildShortView(context, buckets![index]);
          },
        ),
        onRefresh: () async {
          List<Trace>? bucketsTemp = await db.getAllHistory();
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {
            buckets = bucketsTemp;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Center(
        child: FutureBuilder<Widget>(
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
        ),
      ),
    );
  }
}
