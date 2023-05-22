import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'qr_code.dart';

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
      data.mapQRCode(),
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
    return result;
  }
}
