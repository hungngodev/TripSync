import '../database/user_database.dart';
import '../model/user_model.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createUser(User user) async {
    final db = await dbProvider.database;
    print("Adding user to database");
    print("User: ${user.toDatabaseJson()}");
    var result = db.insert(userTable, user.toDatabaseJson());
    return result;
  }

  Future<User> getUser() async {
    final db = await dbProvider.database;
    var result = await db.query(userTable);
    if (result.length > 0) {
      return User.fromDatabaseJson({
        'id': result.first['id'].toString(),
        'username': result.first['username'],
        'token': result.first['token'],
      });
    }
    throw Exception('User not found');
  }

  Future<int> deleteUser(String id) async {
    final db = await dbProvider.database;

    var result = await db.delete(userTable);
    return result;
  }

  Future<bool> checkUser(String id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
