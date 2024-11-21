// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../dao/user_dao.dart';
import 'dart:convert';

class ApiService {
  final userDao = UserDao();
  final String baseUrl =
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000/api/';

  // GET request with endpoint path
  Future<dynamic> getData({Map<String, String>? queryParameters}) async {
    String endpoint = 'activities';
    print(queryParameters);
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

  Future<void> updateChosenActivity(chosenId, activity) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/';
    final url = Uri.parse('$baseUrl$endpoint${chosenId}/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(activity),
    );

    if (response.statusCode == 200) {
      print("Activity updated successfully");
    } else {
      print("Failed to update activity: ${response.statusCode}");
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

  Future<List<Map<String, dynamic>>> getChosenList() async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/chosen_list';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Activity retrieved successfully");
      final selected = json.decode(response.body);
      print("Selected activities: $selected");

      // Ensure that selected is a List of Maps and handle nested data properly
      List<Map<String, dynamic>> selectedActivities =
          List<Map<String, dynamic>>.from(
        selected.map((activity) {
          return {
            'id': activity['activity']['id'], // Extract nested activity ID
            'location': activity['activity']['location'], // Extract location
            'description': activity['activity']
                ['description'], // Extract description
            'chosenId': activity['id'], // Use top-level ID as chosenId
            'title': activity['activity']['title'], // Extract title
          };
        }),
      );
      print("Mapped selected activities: $selectedActivities");
      return selectedActivities;
    } else {
      print("Failed to retrieve activity: ${response.statusCode}");
      return [];
    }
  }

  Future<List<dynamic>> getCalendar() async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/calendar';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Activity retrieved successfully");
      final selected = json.decode(response.body);
      print("Selected activities: $selected");

      // Ensure that selected is a List of Maps and handle nested data properly
      return selected;
    } else {
      print("Failed to retrieve activity: ${response.statusCode}");
      return [];
    }
  }
}
