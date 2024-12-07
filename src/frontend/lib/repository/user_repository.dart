import 'dart:async';
import '../model/user_model.dart';
import '../model/api_model.dart';
import '../api_connection/api_connection.dart';
import '../dao/user_dao.dart';

class UserRepository {
  final userDao = UserDao();
  String userId = '0';
  String userName = 'Traveller';

  Future<User> authenticate({
    required String username,
    required String password,
  }) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    dynamic data = await getToken(userLogin);
    Token token = data['token'] as Token;
    String id = data['id'].toString();
    print(
        'Current user logged in: $username with $id and token: ${token.token}');

    userName = username;
    userId = id;
    User user = User(
      id: id,
      username: username,
      token: token.token,
    );
    return user;
  }

  Future<void> persistToken({required User user}) async {
    // write token with the user to the database
    await userDao.createUser(user);
    print('Token persisted');
  }

  Future<String> getUserId() async {
    return userId;
  }

  Future<String> getUserName() async {
    return userName;
  }

  Future<void> deleteToken({required int id}) async {
    print('DELETING $userId');
    await userDao.deleteUser(userId);
  }

  Future<bool> hasToken() async {
    bool result = await userDao.checkUser(userId);
    print('Has token: $result');
    return result;
  }
}
