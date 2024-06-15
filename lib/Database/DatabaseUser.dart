// import 'dart:ffi';
//
// import 'package:sqflite/sqflite.dart';
//
// import 'CreateDatabase.dart';
//
// class DatabaseUser {
//   Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     //mở kết nối cơ sở dữ liệu
//     _database = await openDatabase("iseeapp.db", version: 1) ;
//     return _database!;
//   }
//   // final database = CreateDatabase().openDatabaseConnection;
//   // init (){
//   //   print("==============================co vo");
//   //   CreateDatabase().createTable(database as Database);
//   // }
//
//
//
//   // Các phương thức để thêm, lấy và xóa dữ liệu vị trí
//   // Future<void> addUser(String username, String password, int? idCane) async {
//   //   final db = await database;
//   //   try {
//   //     await db.insert("user", {
//   //       'username': username,
//   //       'password': password
//   //     });
//   //   } catch (e) {
//   //     print("Error adding user: $e");
//   //   }
//   // }
//   Future<void> addUser(String username, String password, int? idCane) async {
//     final db = await database;
//     try {
//       final Map<String, dynamic> userData = {
//         'username': username,
//         'password': password,
//       };
//
//       // Chỉ thêm idCane vào userData nếu idCane không phải là null
//       if (idCane != null) {
//         userData['idCane'] = idCane;
//       }
//
//       await db.insert("user", userData);
//     } catch (e) {
//       print("Error adding user: $e");
//     }
//   }
//
//   // Future<void> updateUser(String username, String? password, int idCane) async {
//   //   final db = await database;
//   //   try {
//   //     Map<String, dynamic> dataToUpdate = {
//   //       'username': username,
//   //       'idCane': idCane
//   //     };
//   //     if (password != null) {
//   //       dataToUpdate['password'] = password;
//   //     }
//   //     await db.update("user", dataToUpdate, where: "username = ?", whereArgs: [username]);
//   //   } catch (e) {
//   //     print("Error updating user: $e");
//   //   }
//   // }
//   Future<void> updateUser(String username, String? newUsername, String? password, int? idCane, String? name) async {
//     final db = await database;
//     try {
//       Map<String, dynamic> dataToUpdate = {
//         // 'username': username,
//       };
//       if (newUsername != null) {
//         dataToUpdate['username'] = newUsername;
//       }
//       if (password != null) {
//         dataToUpdate['password'] = password;
//       }
//       if (name != null) {
//         dataToUpdate['name'] = name;
//       }
//       if (idCane != null) {
//         dataToUpdate['idCane'] = idCane;
//       }
//
//       await db.update("user", dataToUpdate, where: "username = ?", whereArgs: [username]);
//     } catch (e) {
//       print("Error updating user: $e");
//     }
//   }
//
//   Future<UserRecord?> getUserByUsername(String username)async {
//     try {
//       final db = await database;
//
//       // Thực hiện truy vấn cơ sở dữ liệu để lấy thông tin người dùng theo username
//       List<Map<String, dynamic>> result = await db.query("user", where: "username = ?", whereArgs: [username]);
//
//       // Nếu không có kết quả trả về, trả về null
//       if (result.isEmpty) {
//         return null;
//       }
//
//       // Chuyển đổi dữ liệu từ Map thành đối tượng UserRecord
//       UserRecord user = UserRecord.fromMap(result.first);
//
//       // Trả về thông tin người dùng
//       return user;
//     } catch (e) {
//       // Xử lý các trường hợp lỗi nếu có
//       print("Error fetching user by username: $e");
//       return null;
//     }
//
//   }
//   Future<String?> getPasswordByUsername(String username) async {
//     try {
//       final db = await database;
//
//       // Thực hiện truy vấn cơ sở dữ liệu để lấy mật khẩu của người dùng dựa trên username
//       List<Map<String, dynamic>> result = await db.query(
//         "user",
//         columns: ["password"], // Chỉ lấy cột password
//         where: "username = ?",
//         whereArgs: [username],
//       );
//
//       // Nếu không có kết quả trả về, trả về null
//       if (result.isEmpty) {
//         return null;
//       }
//
//       // Trả về mật khẩu của người dùng
//       return result.first["password"] as String;
//     } catch (e) {
//       // Xử lý các trường hợp lỗi nếu có
//       print("Error fetching password by username: $e");
//       return null;
//     }
//   }
//
//
//   Future<List<UserRecord>> getUsers() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query("user");
//     return maps.map((map) => UserRecord.fromMap(map)).toList();
//   }
//   Future<List<String>> getAllUsername() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query("user", columns: ["username"]);
//     return maps.map((map) => map["username"] as String).toList();
//   }
//
//   Future<void> deleteUser(int id) async {
//     final db = await database;
//     await db.delete("user", where: "idUser = ?", whereArgs: [id]);
//   }
//
//   Future<bool> isCorrectUser(String username, String password) async {
//     final db = await database;
//     var res = await db.rawQuery(
//         "SELECT * FROM user WHERE username = ? and password = ?",
//         [username, password]); // Chú ý đưa tham số vào danh sách tham số
//
//     List<Map<String, dynamic>> list =
//     res.isNotEmpty ? res.toList() : []; // Tránh trả về null, trả về danh sách trống nếu không có kết quả
//
//     return list.isNotEmpty; // Trả về true nếu danh sách không rỗng, ngược lại trả về false
//   }
//
//   Future<List<int>> getIdCaneByUsername(String username) async {
//     final db = await database;
//     try {
//       // Thực hiện truy vấn cơ sở dữ liệu để lấy danh sách idCane theo username
//       List<Map<String, dynamic>> result = await db.query(
//         "user",
//         columns: ["idCane"],
//         where: "username = ?",
//         whereArgs: [username],
//       );
//       // Kiểm tra xem kết quả có rỗng không
//       if (result.isEmpty) {
//         return [];
//       }
//
//       // Chuyển đổi kết quả từ Map thành danh sách int
//       return result.map((map) => map["idCane"] as int).toList();
//     } catch (e) {
//       // Xử lý các trường hợp lỗi nếu có
//       print("Error fetching idCane by username: $e");
//       return [];
//     }
//   }
//
//
// }
//
//
// // Lớp UserRecord để lưu trữ dữ liệu vị trí
// class UserRecord {
//   final int? idUser;
//   final int? idCane; // id có thể là null
//   final String username;
//   final String password;
//   final String? imageAvatar;
//   final String? name;
//
//   UserRecord({
//     this.idUser,
//     this.idCane,
//     required this.username,
//     required this.password,
//     this.imageAvatar,
//     this.name,
//   });
//
//   factory UserRecord.fromMap(Map<String, dynamic> map) => UserRecord(
//     idUser: map['idUser'] as int,
//     idCane: map['idCane'] as int?,
//     username: map['username'] as String,
//     password: map['password'] as String,
//     imageAvatar: map['imageAvatar'] as String?,
//     name: map['name'] as String?
//   );
// }

// ++++++++++++++ mã hóa mật khẩu 1 chiều ++++++++++++++

import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseUser {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    //mở kết nối cơ sở dữ liệu
    _database = await openDatabase("iseeapp.db", version: 1) ;
    return _database!;
  }

  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool _verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  Future<void> addUser(String username, String password, int? idCane) async {
    final db = await database;
    try {
      final Map<String, dynamic> userData = {
        'username': username,
        'password': _hashPassword(password),
      };

      if (idCane != null) {
        userData['idCane'] = idCane;
      }

      await db.insert("user", userData);
    } catch (e) {
      print("Error adding user: $e");
    }
  }
  Future<void> addCaneOfUser(String username, String password, int? idCane) async {
    final db = await database;
    try {
      final Map<String, dynamic> userData = {
        'username': username,
        'password': password,
      };

      if (idCane != null) {
        userData['idCane'] = idCane;
      }

      await db.insert("user", userData);
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  Future<void> updateUser(String username, String? newUsername, String? password, int? idCane, String? name) async {
    final db = await database;
    try {
      Map<String, dynamic> dataToUpdate = {};
      if (newUsername != null) {
        dataToUpdate['username'] = newUsername;
      }
      if (password != null) {
        dataToUpdate['password'] = _hashPassword(password);
      }
      if (name != null) {
        dataToUpdate['name'] = name;
      }
      if (idCane != null) {
        if(idCane == -1){
          dataToUpdate['idCane'] = null;
        }
        else{
          dataToUpdate['idCane'] = idCane;
        }
      }

      await db.update("user", dataToUpdate, where: "username = ?", whereArgs: [username]);
    } catch (e) {
      print("Error updating user: $e");
    }
  }
  Future<void> updateUserAvatar(String username, String avatarPath) async {
    final db = await database;
    await db.update(
      'user',
      {'image': avatarPath},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
  Future<UserRecord?> getUserByUsername(String username) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result = await db.query("user", where: "username = ?", whereArgs: [username]);

      if (result.isEmpty) {
        return null;
      }

      UserRecord user = UserRecord.fromMap(result.first);
      return user;
    } catch (e) {
      print("Error fetching user by username: $e");
      return null;
    }
  }

  Future<String?> getPasswordByUsername(String username) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result = await db.query(
        "user",
        columns: ["password"],
        where: "username = ?",
        whereArgs: [username],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first["password"] as String;
    } catch (e) {
      print("Error fetching password by username: $e");
      return null;
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
  Future<void> deleteCaneOfUser(String username, int idCane) async {
    final db = await database;
    await db.delete("user", where: "username = ? AND idCane = ?", whereArgs: [username, idCane]);
  }
  Future<bool> isCorrectUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
      "user",
      columns: ["password"],
      where: "username = ?",
      whereArgs: [username],
    );

    if (res.isEmpty) {
      return false;
    }

    final hashedPassword = res.first["password"] as String;
    return _verifyPassword(password, hashedPassword);
  }
  // Future<bool> isCorrectPassword(String username, String password) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> res = await db.query(
  //     "user",
  //     columns: ["password"],
  //     where: "username = ?",
  //     whereArgs: [username],
  //   );
  //
  //   if (res.isEmpty) {
  //     return false;
  //   }
  //
  //   final hashedPassword = res.first["password"] as String;
  //   return _verifyPassword(password, hashedPassword);
  // }

  Future<List<int>> getIdCaneByUsername(String username) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        "user",
        columns: ["idCane"],
        where: "username = ?",
        whereArgs: [username],
      );

      if (result.isEmpty) {
        return [];
      }

      return result.map((map) => map["idCane"] as int).toList();
    } catch (e) {
      print("Error fetching idCane by username: $e");
      return [];
    }
  }
  Future<void> hashExistingPasswords() async {
    final db = await database;
    try {
      List<Map<String, dynamic>> users = await db.query("user");

      for (Map<String, dynamic> user in users) {
        String password = user["password"];
        // if (!BCrypt.isHashed(password)) {
          String hashedPassword = _hashPassword(password);
          await db.update(
            "user",
            {"password": hashedPassword},
            where: "idUser = ?",
            whereArgs: [user["idUser"]],
          );
        // }
      }
    } catch (e) {
      print("Error hashing existing passwords: $e");
    }
  }
}

class UserRecord {
  final int? idUser;
  final int? idCane;
  final String username;
  final String password;
  final String? image;
  final String? name;

  UserRecord({
    this.idUser,
    this.idCane,
    required this.username,
    required this.password,
    this.image,
    this.name,
  });

  factory UserRecord.fromMap(Map<String, dynamic> map) => UserRecord(
    idUser: map['idUser'] as int?,
    idCane: map['idCane'] as int?,
    username: map['username'] as String,
    password: map['password'] as String,
    image: map['image'] as String?,
    name: map['name'] as String?,
  );
}


// ++++++++++++++ mã hóa mật khẩu ++++++++++++++


// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
//
// class DatabaseUser {
//   Database? _database;
//   final _key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//   final _iv = encrypt.IV.fromLength(16);
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     // Mở kết nối cơ sở dữ liệu
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'iseeapp.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE user(idUser INTEGER PRIMARY KEY, idCane INTEGER, username TEXT, password TEXT, imageAvatar TEXT, name TEXT)',
//         );
//       },
//       version: 1,
//     );
//     return _database!;
//   }
//
//   String _encryptPassword(String password) {
//     final encrypter = encrypt.Encrypter(encrypt.AES(_key));
//     final encrypted = encrypter.encrypt(password, iv: _iv);
//     return encrypted.base64;
//   }
//
//   String _decryptPassword(String encryptedPassword) {
//     final encrypter = encrypt.Encrypter(encrypt.AES(_key));
//     final decrypted = encrypter.decrypt64(encryptedPassword, iv: _iv);
//     return decrypted;
//   }
//   Future<void> test() async{
//     print("-------------------------------------------");
//     // final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//     // final iv = encrypt.IV.fromLength(16);
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//
//     String password = "0842059055";
//     String encryptedPassword = _encryptPassword(password);
//     String decryptedPassword = _decryptPassword(encryptedPassword);
//
//     print("Original Password: $password");
//     print("Encrypted Password: $encryptedPassword");
//     print("Decrypted Password: $decryptedPassword");
//
//     if (password == decryptedPassword) {
//       print("Mã hóa và giải mã hoạt động chính xác");
//     } else {
//       print("Có lỗi trong quá trình mã hóa hoặc giải mã");
//     }
//   }
//   Future<void> test1() async{
//     print("-------------------------------------------");
//     // final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//     // final iv = encrypt.IV.fromLength(16);
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//
//     String password = "1";
//     String encryptedPassword = _encryptPassword(password);
//     String decryptedPassword = _decryptPassword(encryptedPassword);
//
//     print("Original Password: $password");
//     print("Encrypted Password: $encryptedPassword");
//     print("Decrypted Password: $decryptedPassword");
//
//     if (password == decryptedPassword) {
//       print("Mã hóa và giải mã hoạt động chính xác");
//     } else {
//       print("Có lỗi trong quá trình mã hóa hoặc giải mã");
//     }
//   }
//   Future<void> test0() async{
//     print("-------------------------------------------");
//     // final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//     // final iv = encrypt.IV.fromLength(16);
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//
//     String password = "0";
//     String encryptedPassword = _encryptPassword(password);
//     String decryptedPassword = _decryptPassword(encryptedPassword);
//
//     print("Original Password: $password");
//     print("Encrypted Password: $encryptedPassword");
//     print("Decrypted Password: $decryptedPassword");
//
//     if (password == decryptedPassword) {
//       print("Mã hóa và giải mã hoạt động chính xác");
//     } else {
//       print("Có lỗi trong quá trình mã hóa hoặc giải mã");
//     }
//   }
//   Future<void> test2() async{
//     print("-------------------------------------------");
//     // final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//     // final iv = encrypt.IV.fromLength(16);
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//
//     String password = "ndbaochau104@gmail.com";
//     String encryptedPassword = _encryptPassword(password);
//     String decryptedPassword = _decryptPassword(encryptedPassword);
//
//     print("Original Password: $password");
//     print("Encrypted Password: $encryptedPassword");
//     print("Decrypted Password: $decryptedPassword");
//
//     if (password == decryptedPassword) {
//       print("Mã hóa và giải mã hoạt động chính xác");
//     } else {
//       print("Có lỗi trong quá trình mã hóa hoặc giải mã");
//     }
//   }
//   Future<void> test3() async{
//     print("-------------------------------------------");
//     // final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef'); // Thay bằng khóa của bạn
//     // final iv = encrypt.IV.fromLength(16);
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//
//     String password = "0358650186";
//     String encryptedPassword = _encryptPassword(password);
//     String decryptedPassword = _decryptPassword(encryptedPassword);
//
//     print("Original Password: $password");
//     print("Encrypted Password: $encryptedPassword");
//     print("Decrypted Password: $decryptedPassword");
//
//     if (password == decryptedPassword) {
//       print("Mã hóa và giải mã hoạt động chính xác");
//     } else {
//       print("Có lỗi trong quá trình mã hóa hoặc giải mã");
//     }
//   }
//   Future<void> addUser(String username, String password, int? idCane) async {
//     final db = await database;
//     try {
//       final Map<String, dynamic> userData = {
//         'username': username,
//         'password': _encryptPassword(password),
//       };
//
//       if (idCane != null) {
//         userData['idCane'] = idCane;
//       }
//
//       await db.insert("user", userData);
//     } catch (e) {
//       print("Error adding user: $e");
//     }
//   }
//
//   Future<void> updateUser(String username, String? newUsername, String? password, int? idCane, String? name) async {
//     final db = await database;
//     try {
//       Map<String, dynamic> dataToUpdate = {};
//       if (newUsername != null) {
//         dataToUpdate['username'] = newUsername;
//       }
//       if (password != null) {
//         dataToUpdate['password'] = _encryptPassword(password);
//       }
//       if (name != null) {
//         dataToUpdate['name'] = name;
//       }
//       if (idCane != null) {
//         dataToUpdate['idCane'] = idCane;
//       }
//
//       await db.update("user", dataToUpdate, where: "username = ?", whereArgs: [username]);
//     } catch (e) {
//       print("Error updating user: $e");
//     }
//   }
//
//   Future<UserRecord?> getUserByUsername(String username) async {
//     try {
//       final db = await database;
//       List<Map<String, dynamic>> result = await db.query("user", where: "username = ?", whereArgs: [username]);
//       if (result.isEmpty) {
//         return null;
//       }
//
//       UserRecord user = UserRecord.fromMap(result.first);
//       user.password = _decryptPassword(user.password); // Giải mã mật khẩu trước khi trả về
//       return user;
//     } catch (e) {
//       print("Error fetching user by username: $e");
//       return null;
//     }
//   }
//
//   Future<String?> getPasswordByUsername(String username) async {
//     try {
//       final db = await database;
//       List<Map<String, dynamic>> result = await db.query(
//         "user",
//         columns: ["password"],
//         where: "username = ?",
//         whereArgs: [username],
//       );
//
//       if (result.isEmpty) {
//         return null;
//       }
//
//       return _decryptPassword(result.first["password"] as String);
//     } catch (e) {
//       print("Error fetching password by username: $e");
//       return null;
//     }
//   }
//
//   Future<List<UserRecord>> getUsers() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query("user");
//     return maps.map((map) => UserRecord.fromMap(map)).toList();
//   }
//
//   Future<List<String>> getAllUsername() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query("user", columns: ["username"]);
//     return maps.map((map) => map["username"] as String).toList();
//   }
//
//   Future<void> deleteUser(int id) async {
//     final db = await database;
//     await db.delete("user", where: "idUser = ?", whereArgs: [id]);
//   }
//
//   Future<bool> isCorrectUser(String username, String password) async {
//     final db = await database;
//     var res = await db.rawQuery(
//         "SELECT * FROM user WHERE username = ? and password = ?",
//         [username, _encryptPassword(password)]);
//     print("====================================== pass encrypt:" + _encryptPassword(password));
//     List<Map<String, dynamic>> list = res.isNotEmpty ? res.toList() : [];
//     return list.isNotEmpty;
//   }
//
//   Future<List<int>> getIdCaneByUsername(String username) async {
//     final db = await database;
//     try {
//       List<Map<String, dynamic>> result = await db.query(
//         "user",
//         columns: ["idCane"],
//         where: "username = ?",
//         whereArgs: [username],
//       );
//       if (result.isEmpty) {
//         return [];
//       }
//
//       return result.map((map) => map["idCane"] as int).toList();
//     } catch (e) {
//       print("Error fetching idCane by username: $e");
//       return [];
//     }
//   }
//   Future<void> encryptExistingPasswords() async {
//     final db = await database;
//     // Lấy tất cả các người dùng có mật khẩu chưa được mã hóa
//     List<Map<String, dynamic>> users = await db.query("user");
//     for (var user in users) {
//       String encryptedPassword = _encryptPassword(user['password']);
//       await db.update(
//         "user",
//         {
//           'password': encryptedPassword,
//         },
//         where: "idUser = ?",
//         whereArgs: [user['idUser']],
//       );
//     }
//   }
// }
//
// class UserRecord {
//   final int? idUser;
//   final int? idCane;
//   final String username;
//   String password;
//   final String? imageAvatar;
//   final String? name;
//
//   UserRecord({
//     this.idUser,
//     this.idCane,
//     required this.username,
//     required this.password,
//     this.imageAvatar,
//     this.name,
//   });
//
//   factory UserRecord.fromMap(Map<String, dynamic> map) => UserRecord(
//       idUser: map['idUser'] as int,
//       idCane: map['idCane'] as int?,
//       username: map['username'] as String,
//       password: map['password'] as String,
//       imageAvatar: map['imageAvatar'] as String?,
//       name: map['name'] as String?
//   );
// }

