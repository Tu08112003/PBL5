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
  Future<List<LocationRecord>> getAllLocationsByID(int idCane) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM location WHERE idCane = ?",
        [idCane]);

    List<Map<String, dynamic>> list =
    res.isNotEmpty ? res.toList() : [];

    return list.map((map) => LocationRecord.fromMap(map)).toList();
  }

  Future<List<int>> getDatetimesByIDCane(int idCane) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT timestamp FROM location WHERE idCane = ?",
        [idCane]);

    List<int> timestamps = [];
    for (var row in res) {
      timestamps.add(row['timestamp'] as int);
    }

    return timestamps;
  }

  Future<void> addLocationForExistServer(String ipServer, int idCane) async {
    try {
      final db = await database;

      // Lấy danh sách các idCane từ bảng cane
      List<Map<String, dynamic>> idResults = await db.rawQuery(
        "SELECT idCane FROM cane WHERE ipServer = ?",
        [ipServer],
      );

      List<int> listIDs = idResults.map((e) => e['idCane'] as int).toList();

      // Danh sách để lưu trữ các location
      List<Map<String, dynamic>> listLocations = [];
      // Lặp qua từng idCane và lấy các location tương ứng
      for (int id in listIDs) {
        List<Map<String, dynamic>> locations = await db.rawQuery(
          "SELECT latitude, longitude, timestamp FROM location WHERE idCane = ?",
          [id],
        );
        listLocations.addAll(locations);
        int i = 1;
        // Thêm từng location vào hệ thống bằng phương thức addLocation
        for (var location in locations) {
          double latitude = location['latitude'];
          double longitude = location['longitude'];
          int timestamp = location['timestamp'];

          // Gọi phương thức addLocation
          addLocation(latitude, longitude, timestamp, idCane);

          print("======them location cho id cane:"+idCane.toString() +"---- lần :" +i.toString());
          i++;
        }
      }

      if (listLocations.isEmpty) {
        print("No locations found.");
      } else {
        print("Locations found:");
        for (var location in listLocations) {
          print(location);
        }
      }

    } catch (e) {
      // Xử lý các trường hợp lỗi nếu có
      print("Error checking existence of cane: $e");
    }
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
