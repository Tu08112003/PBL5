import 'package:sqflite/sqflite.dart';

import 'CreateDatabase.dart';

class DatabaseLocation {
  Database? _database;
  Future<Database> get database async {
    //mở kết nối cơ sở dữ liệu
    _database = await openDatabase("iseeapp.db", version: 1) ;
    return _database!;
  }
  // final database = CreateDatabase().openDatabaseConnection;
  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  Future<void> addLocation(double latitude, double longitude, int timestamp, int idCane) async {
    final db = await database;
    try {
      await db.insert("location", {
        'idCane': idCane,
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
    final List<Map<String, dynamic>> maps = await db.query("location");
    return maps.map((map) => LocationRecord.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete("location", where: "idLocation = ?", whereArgs: [id]);
  }
  Future<List<LocationRecord>> getAllLocationsByIP(int ipCane) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM location WHERE idCane = ?",
        [ipCane]);

    List<Map<String, dynamic>> list =
    res.isNotEmpty ? res.toList() : [];

    return list.map((map) => LocationRecord.fromMap(map)).toList();
  }
}

// Lớp LocationRecord để lưu trữ dữ liệu vị trí
class LocationRecord {
  final int? idLocation;
  final int? idCane; // id có thể là null
  final double latitude;
  final double longitude;
  final int timestamp;

  LocationRecord({
    this.idLocation,
    this.idCane,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationRecord.fromMap(Map<String, dynamic> map) => LocationRecord(
    idLocation: map['idLocation'] as int,
    idCane: map['idCane'] as int,
    latitude: map['latitude'] as double,
    longitude: map['longitude'] as double,
    timestamp: map['timestamp'] as int,
  );
}
