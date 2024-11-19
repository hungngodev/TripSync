import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as path;
import 'dart:html';
import 'database_provider.dart';

const userTable = 'userTable';

class WebDatabaseProvider implements DatabaseProvider {
  static final WebDatabaseProvider _instance = WebDatabaseProvider._internal();
  factory WebDatabaseProvider() => _instance;
  WebDatabaseProvider._internal();

  late Database _database;
  final _userStore = intMapStoreFactory.store(userTable);

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = path.join(window.location.pathname ?? '', 'user.db');
    DatabaseFactory dbFactory = databaseFactoryIo;
    return await dbFactory.openDatabase(dbPath);
  }

  @override
  Future<void> initDB() async {
    await database;
  }

  @override
  Future<void> insertUser(String username, String token) async {
    await _userStore.add(_database, {'username': username, 'token': token});
  }
}
