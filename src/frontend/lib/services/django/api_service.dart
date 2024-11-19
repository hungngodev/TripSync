// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../dao/user_dao.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://localhost:8000/api';
  final userDao = UserDao();
  // final String baseUrl =
  //     dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000/api';

  // GET request with endpoint path
  Future<dynamic> getData({Map<String, String>? queryParameters}) async {
    String endpoint = 'activities';
    final uri = Uri.parse('$baseUrl$endpoint')
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
    final uri = Uri.parse('$baseUrl$endpoint')
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

  // Future<String> createChosenList(chosenList) async {
  //   print('Chosen list: $chosenList');
  //   final user = await userDao.getUser();
  //   print('User: $user');
  //   final token = user.token;
  //   const endpoint = 'chosen-activities/bulk_create/';
  //   final url = Uri.parse('$baseUrl$endpoint');
  //   print('Chosen list: $chosenList');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Token $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode(chosenList), // Encode the list to JSON
  //   );

  //   if (response.statusCode == 201) {
  //     print("Activities added successfully: ${response.body}");
  //     return json.decode(response.body)['id'];
  //   } else {
  //     print("Failed to add activities: ${response.statusCode}");
  //     return '';
  //   }
  // }

  Future<String> addChosenActivity(activity) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/';
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(activity),
    );

    if (response.statusCode == 201) {
      print("Activity added successfully: ${response.body}");
      return json.decode(response.body)['id'].toString();
    } else {
      print("Failed to add activity: ${response.statusCode}");
      return '';
    }
  }

  Future<void> deleteChosenActivity(id) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/';
    final url = Uri.parse('$baseUrl$endpoint$id/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      print("Activity deleted successfully");
    } else {
      print("Failed to delete activity: ${response.statusCode}");
    }
  }
}
