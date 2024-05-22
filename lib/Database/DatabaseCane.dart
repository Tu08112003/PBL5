
import 'package:sqflite/sqflite.dart';

import 'CreateDatabase.dart';

class DatabaseCane {
  Database? _database;
  Future<Database> get database async {
    //mở kết nối cơ sở dữ liệu
    _database = await openDatabase("iseeapp.db", version: 1) ;
    return _database!;
  }
  // final database = CreateDatabase().openDatabaseConnection;
  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  Future<void> addCane(String ipServer, String nickname) async {
    final db = await database;
    try {
      await db.insert("cane", {
        'ipServer': ipServer,
        'nickname': nickname,
      });
      print("Add cane successfully");
    } catch (e) {
      print("Error adding cane: $e");
    }
  }

  Future<List<CaneRecord>> getCanes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("cane");
    return maps.map((map) => CaneRecord.fromMap(map)).toList();
  }

  Future<void> deleteCane(int id) async {
    final db = await database;
    await db.delete("cane", where: "idCane = ?", whereArgs: [id]);
  }
}

// Lớp CaneRecord để lưu trữ dữ liệu vị trí
class CaneRecord {
  // final int id;
  final int? idCane; // id có thể là null
  final String ipServer;
  final String nickname;
  final String? image;
  final String? ipCam;

  CaneRecord({
    this.idCane,
    required this.ipServer,
    required this.nickname,
    this.image,
    this.ipCam,
  });

  factory CaneRecord.fromMap(Map<String, dynamic> map) => CaneRecord(
    idCane: map['idCane'] as int,
    ipServer: map['ipServer'] as String,
    nickname: map['nickname'] as String,
    image: map['image'] as String,
    ipCam: map['ipCam'] as String,
  );
}
