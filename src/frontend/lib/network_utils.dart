import 'package:http/http.dart' as http;

class NetworkUtils {
  static void addIfNotNull(
      Map<String, dynamic> queryParams, MapEntry<String, dynamic> entry) {
    if (entry.value != null) queryParams[entry.key] = entry.value;
  }

  static Future<http.Response> getRequest(Uri uri,
      {Map<String, dynamic>? headers}) async {
    return await http.get(uri);
  }
}