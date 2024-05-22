import 'package:sqflite/sqflite.dart';

class DatabaseCane {
  static final _databaseName = "cane_information.db";
  static final _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Tạo hoặc mở kết nối cơ sở dữ liệu
    _database = await openDatabase(_databaseName, version: _databaseVersion,
        onCreate: (db, version) async {
          // Tạo bảng 'locations' trong cơ sở dữ liệu
          await db.execute("CREATE TABLE cane (idCane INTEGER PRIMARY KEY AUTOINCREMENT, ipServer String)");
        });
    return _database!;
  }

  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  Future<void> addLocation(String ipServer) async {
    final db = await database;
    try {
      await db.insert("cane", {
        'ipServer': ipServer,
      });
    } catch (e) {
      print("Error adding location: $e");
    }
  }

  Future<List<LocationRecord>> getLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("cane");
    return maps.map((map) => LocationRecord.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete("cane", where: "idCane = ?", whereArgs: [id]);
  }
}

// Lớp LocationRecord để lưu trữ dữ liệu vị trí
class LocationRecord {
  // final int id;
  final int? idCane; // id có thể là null
  final String ipServer;

  LocationRecord({
    this.idCane,
    required this.ipServer,
  });

  factory LocationRecord.fromMap(Map<String, dynamic> map) => LocationRecord(
    idCane: map['idCane'] as int,
    ipServer: map['ipServer'] as String,
  );
}
