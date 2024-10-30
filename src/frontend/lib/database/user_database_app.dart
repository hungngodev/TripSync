import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';

const userTable = 'userTable';

class MobileDatabaseProvider implements DatabaseProvider {
  static final MobileDatabaseProvider _instance =
      MobileDatabaseProvider._internal();
  factory MobileDatabaseProvider() => _instance;
  MobileDatabaseProvider._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "User.db");

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $userTable ("
            "id INTEGER PRIMARY KEY, "
            "username TEXT, "
            "token TEXT "
            ")");
      },
    );
    return database;
  }

  @override
  Future<void> initDB() async {
    await database;
  }

  @override
  Future<void> insertUser(String username, String token) async {
    final db = await database;
    await db.insert(userTable, {'username': username, 'token': token});
  }
}
