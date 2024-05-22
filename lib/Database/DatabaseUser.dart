import 'dart:ffi';

import 'package:sqflite/sqflite.dart';

import 'CreateDatabase.dart';

class DatabaseUser {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    //mở kết nối cơ sở dữ liệu
    _database = await openDatabase("iseeapp.db", version: 1) ;
    return _database!;
  }
  // final database = CreateDatabase().openDatabaseConnection;
  // init (){
  //   print("==============================co vo");
  //   CreateDatabase().createTable(database as Database);
  // }



  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  Future<void> addUser(String username, String password) async {
    final db = await database;
    try {
      await db.insert("user", {
        'username': username,
        'password': password
      });
    } catch (e) {
      print("Error adding user: $e");
    }
  }
  Future<void> updateUser(int idUser, String username, String password, int idCane) async {
    final db = await database;
    try {
      await db.update("user", where: "idUser = ?", whereArgs: [idUser], {
        'username': username,
        'password': password,
        'idCane': idCane
      });
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  Future<List<UserRecord>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("user");
    return maps.map((map) => UserRecord.fromMap(map)).toList();
  }
  Future<List<String>> getAllUsername() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("user", columns: ["username"]);
    return maps.map((map) => map["username"] as String).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete("user", where: "idUser = ?", whereArgs: [id]);
  }

  Future<bool> isCorrectUser(String username, String password) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM user WHERE username = ? and password = ?",
        [username, password]); // Chú ý đưa tham số vào danh sách tham số

    List<Map<String, dynamic>> list =
    res.isNotEmpty ? res.toList() : []; // Tránh trả về null, trả về danh sách trống nếu không có kết quả

    return list.isNotEmpty; // Trả về true nếu danh sách không rỗng, ngược lại trả về false
  }


}


// Lớp UserRecord để lưu trữ dữ liệu vị trí
class UserRecord {
  final int? idUser;
  final int? idCane; // id có thể là null
  final String username;
  final String password;
  final String? imageAvatar;
  final String? name;

  UserRecord({
    this.idUser,
    this.idCane,
    required this.username,
    required this.password,
    this.imageAvatar,
    this.name,
  });

  factory UserRecord.fromMap(Map<String, dynamic> map) => UserRecord(
    idUser: map['idUser'] as int,
    idCane: map['idCane'] as int,
    username: map['username'] as String,
    password: map['password'] as String,
    imageAvatar: map['imageAvatar'] as String,
    name: map['name'] as String
  );
}
