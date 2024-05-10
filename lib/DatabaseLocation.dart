import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "location_history.db";
  static final _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Tạo hoặc mở kết nối cơ sở dữ liệu
    _database = await openDatabase(_databaseName, version: _databaseVersion,
        onCreate: (db, version) async {
          // Tạo bảng 'locations' trong cơ sở dữ liệu
          await db.execute("CREATE TABLE locations (id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, timestamp INTEGER)");
        });
    return _database!;
  }

  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  Future<void> addLocation(double latitude, double longitude, int timestamp) async {
    final db = await database;
    try {
      await db.insert("locations", {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
      });
    } catch (e) {
      print("Error adding location: $e");
    }
  }

  Future<List<LocationRecord>> getLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("locations");
    return maps.map((map) => LocationRecord.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete("locations", where: "id = ?", whereArgs: [id]);
  }
}

// Lớp LocationRecord để lưu trữ dữ liệu vị trí
class LocationRecord {
  // final int id;
  final int? id; // id có thể là null
  final double latitude;
  final double longitude;
  final int timestamp;

  LocationRecord({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationRecord.fromMap(Map<String, dynamic> map) => LocationRecord(
    id: map['id'] as int,
    latitude: map['latitude'] as double,
    longitude: map['longitude'] as double,
    timestamp: map['timestamp'] as int,
  );
}
