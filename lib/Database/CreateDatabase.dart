import 'package:sqflite/sqflite.dart';
class CreateDatabase{
  Future<Database> openDatabaseConnection() async {
    const databaseName = 'iseeapp.db';
    const databaseVersion = 1; // Adjust if necessary

    // Open the database
    Database db = await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: (db, version) async {
        // Tạo bảng 'cane' trước
        await db.execute("CREATE TABLE IF NOT EXISTS cane (idCane INTEGER PRIMARY KEY AUTOINCREMENT, ipServer VARCHAR(50), nickname VARCHAR(50), image VARCHAR(50) NULL, ipCam VARCHAR(50) NULL)");
        print("=============================== tao cane");

        // Tạo bảng 'user' sau
        await db.execute("CREATE TABLE IF NOT EXISTS user (idUser INTEGER PRIMARY KEY AUTOINCREMENT, idCane INTEGER NULL, username VARCHAR(50) NOT NULL, password VARCHAR(50) NOT NULL, name VARCHAR(50) NULL, image VARCHAR(100) NULL, FOREIGN KEY (idCane) REFERENCES cane(idCane))");
        print("=============================== tao user");
        await db.execute("CREATE TABLE IF NOT EXISTS location (idLocation INTEGER PRIMARY KEY AUTOINCREMENT, idCane INTEGER, latitude REAL, longitude REAL, timestamp INTEGER, FOREIGN KEY (idCane) REFERENCES cane(idCane))");
        print("=============================== tao location");
        await db.close();
      },
    );

    return db;
  }

  Future<void> createTable(Database db) async {

  }

  Future<void> createTableWithDb() async {
    // Open the database connection
    final db = await openDatabaseConnection();

    print("========================db:");
    print(db);
    print(db.database);
    // Create the table
    await createTable(db);

    // Close the database connection
    await db.close();
  }

}



