abstract class DatabaseProvider {
  Future<void> initDB();
  Future<void> insertUser(String username, String token);
}
