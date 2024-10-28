// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl =
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000/api';

  // GET request with endpoint path
  Future<dynamic> getData(String endpoint,
      {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl/$endpoint')
        .replace(queryParameters: queryParameters);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // POST request with optional query parameters and data
  Future<dynamic> postData(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl/$endpoint')
        .replace(queryParameters: queryParameters);
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Error posting data: $e');
    }
  }
}
