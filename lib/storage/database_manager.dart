import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'ds_trace.dart';

import 'ds_qr_code.dart';

abstract class _DatabaseInitializer {
  static Database? _database;

  Future<Database> _openDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), "storage.db"),
      version: 1,
      onCreate: _createTables,
    );
    return _database!;
  }

  Future<Database> _getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await _openDB();
    }
  }

  void _createTables(Database db, int version);
}

class DatabaseManager extends _DatabaseInitializer {
  @override
  void _createTables(Database db, int version) async {
    await db.execute("""
          CREATE TABLE qr_codes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            qr_id TEXT NOT NULL,
            part_no INTEGER NOT NULL,
            part_total INTEGER NOT NULL,
            qr_title TEXT,
            qr_content TEXT
          );
        """);
    await db.execute("""
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            datetime TEXT NOT NULL,
            activity TEXT NOT NULL
          );
        """);
    await db.execute("""
          CREATE TABLE qr_keys(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key_id TEXT NOT NULL,
            key_title TEXT,
            key_content TEXT
          );
        """);
    // ... More tables
  }

  Future<void> insertQRCode({required QRCode data}) async {
    final db = await _getDB();
    await db.insert(
      "qr_codes",
      data.mapToDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Trace trace =
        Trace(activity: "New scan - QR Note #${data.qrId}: ${data.title}");
    await db.insert(
      "history",
      trace.mapToDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteQRCode({required QRCode data}) async {
    final db = await _getDB();
    await db.delete("qr_codes", where: "qr_id = ?", whereArgs: [data.qrId]);
    Trace trace =
        Trace(activity: "Deleted - QR Note #${data.qrId}: ${data.title}");
    await db.insert(
      "history",
      trace.mapToDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QRCode>> getAllQRCodes() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query("qr_codes");
    List<QRCode> result = [];
    for (Map map in maps) {
      result.add(QRCode(
        qrId: map["qr_id"],
        partNo: map["part_no"],
        partTotal: map["part_total"],
        title: map["qr_title"],
        content: map["qr_content"],
      ));
    }
    return result.reversed.toList();
  }

  Future<List<Trace>> getAllHistory() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query("history");
    List<Trace> result = [];
    for (Map map in maps) {
      result.add(Trace(
        datetime: map["datetime"],
        activity: map["activity"],
      ));
    }
    return result.reversed.toList();
  }
}
