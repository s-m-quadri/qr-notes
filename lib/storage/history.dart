import 'package:flutter/material.dart';

class History {
  History({
    this.datetime,
    required this.activity,
  });

  String? datetime;
  String activity;

  // For database, column to data unit match
  Map<String, dynamic> mapToDB() {
    return {
      "datetime": DateTime.now().toString(),
      "activity": activity,
    };
  }
}
