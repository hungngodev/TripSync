import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/api_model.dart';

final String _base = dotenv.env['AUTH_URL'] ?? 'http://localhost:8000/api/';
const _tokenEndpoint = "token-auth";
final String _tokenURL = _base + _tokenEndpoint;

Future<Map<String, dynamic>> getToken(UserLogin userLogin) async {
  print('Token retrieved');
  final http.Response response = await http.post(
    Uri.parse(_tokenURL), // Wrap the URL in Uri.parse
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return {
      "token": Token.fromJson(json.decode(response.body)),
      "id": json.decode(response.body)['id'],
    };
  } else {
    final errorMessage = json.decode(response.body)['error'] ?? 'Unknown error';
    print(errorMessage);
    throw Exception('Failed to retrieve token: $errorMessage');
  }
}
