import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../services/django/api_service.dart';

class Friend {
  String friendName;
  String friendImage;
  String friendStatus;
  int friendId;
  int mutuals;
  bool isFriend;
  bool isRequested;
  bool isSuggested;
  Friend({
    required this.friendName,
    required this.friendImage,
    required this.friendStatus,
    required this.friendId,
    required this.mutuals,
    required this.isFriend,
    required this.isRequested,
    required this.isSuggested,
  });
}

class FriendProvider with ChangeNotifier {
  List<Friend> _friends = [];
  final apiService = ApiService();

  Future<void> fetchFriends() async {
    final response = await apiService.getFriends();
    _friends = response.map<Friend>((f) => processData(f)).toList();
    notifyListeners();
  }
}
