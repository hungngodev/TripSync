import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/api_model.dart';

var _base = dotenv.env['AUTH_URL'] ?? 'http://localhost:8000/';
const _tokenEndpoint = "/api-token-auth/";
var _tokenURL = _base + _tokenEndpoint;

Future<Token> getToken(UserLogin userLogin) async {
  print('Getting token...');
  print(_tokenURL);

  final http.Response response = await http.post(
    Uri.parse(_tokenURL), // Wrap the URL in Uri.parse
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );

  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    final errorMessage = json.decode(response.body)['error'] ?? 'Unknown error';
    print(errorMessage);
    throw Exception('Failed to retrieve token: $errorMessage');
  }
}
