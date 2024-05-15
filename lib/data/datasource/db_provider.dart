import 'package:flutter_sqflite_fetchdata/data/model/user_model.dart';
import 'package:flutter_sqflite_fetchdata/util/extentions/string_extention.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  static const tableUserCreationQuery =
      ''' CREATE TABLE IF NOT EXISTS TBUser (id INTEGER PRIMERY Key, firstName TEXT, lastName TEXT, phone TEXT, image TEXT);''';
  Future<Database> initDB() async {
    const int version = 1;
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "database.db");
    return await openDatabase(
      path,
      version: version,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(tableUserCreationQuery);
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }

  Future<void> addUsers(List<User> users) async {
    final db = await database;
    await db.transaction(
      (txn) async {
        for (var element in users) {
          await txn.delete('TBUser', where: 'id = ?', whereArgs: [element.id]);
          await txn.rawInsert(
              'INSERT INTO TBUser (id,firstName,lastName,phone,image) Values (${element.id}, "${element.firstName}", "${element.lastName}", "${element.phone}", "${element.image}")');
        }
      },
    );
  }

  Future<List<User>> loadUsers() async {
    final db = await database;
    List<Map<String, dynamic>> rows =
        await db.rawQuery('Select id, firstname, lastName, phone From TBUser');
    return rows.map((e) => User.fromJson(e.toLowerCase())).toList();
  }
}
