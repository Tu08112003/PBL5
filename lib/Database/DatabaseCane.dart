
import 'package:sqflite/sqflite.dart';

class DatabaseCane {
  Database? _database;
  Future<Database> get database async {
    //mở kết nối cơ sở dữ liệu
    _database = await openDatabase("iseeapp.db", version: 1) ;
    return _database!;
  }
  // final database = CreateDatabase().openDatabaseConnection;
  // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
  // Future<void> addCane(String ipServer, String nickname) async {
  //   final db = await database;
  //   try {
  //     await db.insert("cane", {
  //       'ipServer': ipServer,
  //       'nickname': nickname,
  //     });
  //     print("Add cane successfully");
  //   } catch (e) {
  //     print("Error adding cane: $e");
  //   }
  // }
  Future<int> addCane(String ipServer, String nickname) async {
    final db = await database;
    try {
      int id = await db.insert("cane", {
        'ipServer': ipServer,
        'nickname': nickname,
      });
      print("Add cane successfully with id: $id");
      return id;
    } catch (e) {
      print("Error adding cane: $e");
      return -1;
    }
  }
  Future<void> updateCane(int idCane, String? ipServer, String? ipCam, String? nickname) async {
    final db = await database;
    try {
      Map<String, dynamic> dataToUpdate = {};
      if (ipServer != null) {
        dataToUpdate['ipServer'] = ipServer;
      }
      if (ipCam != null) {
        if (ipCam == '-1') {
          dataToUpdate['ipCam'] = null;
        }
        else{
          dataToUpdate['ipCam'] = ipCam;
        }
      }

      if (nickname != null) {
        dataToUpdate['nickname'] = nickname;
      }

      await db.update("cane", dataToUpdate, where: "idCane = ?", whereArgs: [idCane]);
    } catch (e) {
      print("Error updating cane: $e");
    }
  }
  Future<void> updateCaneAvatar(int idCane, String avatarPath) async {
    final db = await database;
    await db.update(
      'cane',
      {'image': avatarPath},
      where: 'idCane = ?',
      whereArgs: [idCane],
    );
  }

  Future<bool> isUserExistCane(String username, int? idCane)async{
    try {
      final db = await database;
      List<Map<String, dynamic>> userResult = await db.rawQuery(
          "SELECT * FROM user WHERE username = ? and idCane = ?",
          [username, idCane]);
      if (userResult.isEmpty) {
        return false;
      }
      else{
        return true;
      }

    } catch (e) {
      // Xử lý các trường hợp lỗi nếu có
      print("Error checking existence of cane: $e");
      return false;
    }
  }
  Future<bool> isExistCane(String username, String ipServer) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db.query("cane", where: "ipServer = ?", whereArgs: [ipServer]);


      if (results.isNotEmpty) {
        for(Map<String, dynamic> result in results){
          print("có vô đây");
          CaneRecord cane = CaneRecord.fromMap(result);
          print("--------"+cane.idCane!.toString());
          if (await isUserExistCane(username, cane.idCane!)) {
            print("vô-------" + cane.idCane!.toString());
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking existence of cane: $e");
      return false;
    }
  }
  Future<CaneRecord?> getCaneByID(int id)async {
    try {
      final db = await database;

      // Thực hiện truy vấn cơ sở dữ liệu để lấy thông tin người dùng theo username
      List<Map<String, dynamic>> result = await db.query("cane", where: "idCane = ?", whereArgs: [id]);

      // Nếu không có kết quả trả về, trả về null
      if (result.isEmpty) {
        return null;
      }

      // Chuyển đổi dữ liệu từ Map thành đối tượng UserRecord
      CaneRecord caneRecord = CaneRecord.fromMap(result.first);

      // Trả về thông tin người dùng
      return caneRecord;
    } catch (e) {
      // Xử lý các trường hợp lỗi nếu có
      print("Error fetching user by username: $e");
      return null;
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

  Future<List<int>> getListIdCanesByIpServer(String ipServer) async {
    try {
      final db = await database;

      // Lấy danh sách các idCane từ bảng cane
      List<Map<String, dynamic>> idResults = await db.rawQuery(
        "SELECT idCane FROM cane WHERE ipServer = ?",
        [ipServer],
      );

      List<int> listIDs = idResults.map((e) => e['idCane'] as int).toList();
      return listIDs;
    } catch (e) {
      // Xử lý các trường hợp lỗi nếu có
      print("Error checking existence of cane: $e");
      return [];
    }
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
    image: map['image'] as String?,
    ipCam: map['ipCam'] as String?,
  );
}
