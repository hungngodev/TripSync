// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../dao/user_dao.dart';
import 'dart:convert';

class ApiService {
  final userDao = UserDao();
  final String baseUrl =
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000/api/';
  final String userUrl = dotenv.env['AUTH_URL'] ?? 'http://localhost:8000/api/';

  // GET request with endpoint path
  Future<dynamic> getData({Map<String, String>? queryParameters}) async {
    String endpoint = 'activities';
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: queryParameters);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 201 || response.statusCode == 200) {
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

    if (response.statusCode == 201 || response.statusCode == 200) {
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

    if (response.statusCode == 201 || response.statusCode == 200) {
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

  Future<List<Map<String, dynamic>>> getChosenList(calendarId) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/chosen_list';
    final url = Uri.parse('$baseUrl$endpoint/?calendar=$calendarId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Activity retrieved successfully");
      final selected = json.decode(response.body);
      // print("Selected activities: $selected");

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
            'category': activity['activity']['category'], // Extract category
            'source_link': activity['activity']
                ['source_link'], // Extract source_link
            'address': activity['activity']['address'], // Extract address
          };
        }),
      );
      // print("Mapped selected activities: $selectedActivities");
      return selectedActivities;
    } else {
      print("Failed to retrieve activity: ${response.statusCode}");
      return [];
    }
  }

  Future<List<dynamic>> getTodayCalendar() async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'chosen-activities/today';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Activity retrieved successfully");
      final selected = json.decode(response.body);
      // print("Selected activities: $selected");
      return selected;
    } else {
      print("Failed to retrieve activity: ${response.statusCode}");
      return [];
    }
  }

  Future<List<dynamic>> getCalendar(id) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'chosen-activities/$id/calendar';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Activity retrieved successfully");
      final selected = json.decode(response.body);
      // print("Selected Calendar activities $id: $selected");

      // Ensure that selected is a List of Maps and handle nested data properly
      return selected;
    } else {
      print("Failed to retrieve activity: ${response.statusCode}");
      return [];
    }
  }

  Future<String> createCalendar(name) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'calendars';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.post(url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': name}));
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Calendar created successfully");
      return json.decode(response.body)['id'].toString();
    } else {
      print("Failed to create calendar: ${response.statusCode}");
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> getCalendars() async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'calendars';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Calendars retrieved successfully");
      final calendars = json.decode(response.body);
      // print("Calendars: $calendars");

      // Ensure that selected is a List of Maps and handle nested data properly
      List<Map<String, dynamic>> calendarList = List<Map<String, dynamic>>.from(
        calendars.map((calendar) {
          return {
            'id': calendar['id'].toString(),
            'name': calendar['name'],
            'created_at': calendar['created_at'],
          };
        }),
      );
      // print("Mapped calendars: $calendarList");
      return calendarList;
    } else {
      print("Failed to retrieve calendars: ${response.statusCode}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDetailedCalendars() async {
    print('Getting detailed calendars');
    final user = await userDao.getUser();
    final token = user.token;
    const endpoint = 'calendars';
    final url = Uri.parse('$baseUrl$endpoint/?detail=true');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Detailed Calendars retrieved successfully");
      final calendars = json.decode(response.body);

      // Ensure that selected is a List of Maps and handle nested data properly
      List<Map<String, dynamic>> calendarList = List<Map<String, dynamic>>.from(
        calendars.map((calendar) {
          return {
            'id': calendar['id'].toString(),
            'name': calendar['name'],
            'created_at': calendar['created_at'],
            'events': calendar['events'],
          };
        }),
      );
      return calendarList;
    } else {
      print("Failed to retrieve detailed calendars: ${response.statusCode}");
      return [];
    }
  }

  Future<List<dynamic>> getPosts() async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoints = 'posts';
    final url = Uri.parse('$baseUrl$endpoints/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Post fetched successfully");
      return json.decode(response.body);
    } else {
      print("Failed to fetch posts: ${response.statusCode}");
    }

    return [];
  }

  Future<dynamic> addPost(post) async {
    final user = await userDao.getUser();
    final token = user.token;
    const endpoints = 'posts';
    final url = Uri.parse('$baseUrl$endpoints/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(post),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Post added successfully");
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print("Failed to add post: ${response.statusCode}");
    }

    return;
  }

  Future<dynamic> editPost(id, post) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoints = 'posts/$id';
    final url = Uri.parse('$baseUrl$endpoints/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(post),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Post edited successfully");
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print("Failed to edit post: ${response.statusCode}");
    }

    return;
  }

  Future<void> deletePost(id) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'posts/$id';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 ||
        response.statusCode == 200 ||
        response.statusCode == 204) {
      print("Post delete successfully");
    } else {
      print("Failed to delete post: ${response.statusCode}");
    }

    return;
  }

  Future<void> toggleLike(id, like) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'posts/$id/like';
    final url = Uri.parse('$baseUrl$endpoint/');
    print('id: $id, like: $like');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'like': like}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Post liked successfully");
    } else {
      print("Failed to like post: ${response.statusCode}");
    }
  }

  Future<int> addFriend(friend) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'friends';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'friend': friend,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Friend added successfully");
      return json.decode(response.body)['id'];
    } else {
      print("Failed to add friend: ${response.statusCode}");
      return 0;
    }
  }

  Future<void> acceptFriend(
    id,
  ) async {
    print('Accepting friend request');
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'friends/$id';
    final url = Uri.parse('$baseUrl$endpoint/');
    print('Accepting friend request');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status': true,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Friend accepted successfully");
    } else {
      print("Failed to accept friend: ${response.statusCode}");
    }
  }

  Future<void> removeFriend(id) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'friends/$id';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Friend removed successfully");
    } else {
      print("Failed to remove friend: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> getFriends() async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'friends';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Friends fetched successfully");
      return json.decode(response.body);
    } else {
      print("Failed to fetch friends: ${response.statusCode}");
    }

    return [];
  }

  Future<List<dynamic>> getSuggestedFriends() async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'user/?random=true';
    final url = Uri.parse('$userUrl$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Suggested friends fetched successfully");
      return json.decode(response.body);
    } else {
      print("Failed to fetch suggested friends: ${response.statusCode}");
    }

    return [];
  }

  Future<bool> deleteCalendar(calendarId) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'calendars/$calendarId';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      print("Calendar deleted successfully");
      return true;
    } else {
      print("Failed to delete calendar: ${response.statusCode}");
      return false;
    }
  }

  Future<void> inviteCalendar(calendarId, friendId) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'invite-calendars/';
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'calendar': calendarId,
        'friend': friendId,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Calendar invited successfully");
    } else {
      print("Failed to invite calendar: ${response.statusCode}");
    }
  }

  Future<void> acceptCalendarInvite(id) async {
    final user = await userDao.getUser();
    final token = user.token;
    String endpoint = 'invite-calendars/$id';
    final url = Uri.parse('$baseUrl$endpoint/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status': true,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Calendar invite accepted successfully");
    } else {
      print("Failed to accept calendar invite: ${response.statusCode}");
    }
  }

  // Future<List<dynamic>> getRequests() async {
  //   final user = await userDao.getUser();
  //   final token = user.token;
  //   String endpoint = 'friends/get_sent';
  //   final url = Uri.parse('$baseUrl$endpoint/');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Authorization': 'Token $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     print("Requests fetched successfully");
  //     return json.decode(response.body);
  //   } else {
  //     print("Failed to fetch requests: ${response.statusCode}");
  //   }

  //   return [];
  // }

  // Future<List<dynamic>> getReceives() async {
  //   final user = await userDao.getUser();
  //   final token = user.token;
  //   String endpoint = 'friends/get_receive';
  //   final url = Uri.parse('$baseUrl$endpoint/');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Authorization': 'Token $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     print("Receives fetched successfully");
  //     return json.decode(response.body);
  //   } else {
  //     print("Failed to fetch receives: ${response.statusCode}");
  //   }

  //   return [];
  // }
}
