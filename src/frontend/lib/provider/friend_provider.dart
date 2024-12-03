import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../services/django/api_service.dart';

class Friend {
  int id;
  String friendName;
  String friendImage;
  String friendStatus;
  int friendId;
  int mutuals;
  bool isFriend;
  bool isRequested;
  bool isSuggested;
  bool isReceiving;
  DateTime friendSince;
  int friendshipId;
  Friend({
    required this.friendName,
    required this.friendImage,
    required this.friendStatus,
    required this.friendId,
    required this.mutuals,
    required this.isFriend,
    required this.isRequested,
    required this.isSuggested,
    required this.isReceiving,
    required this.friendSince,
    required this.friendshipId,
    required this.id,
  });
}

class FriendProvider with ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> _suggestions = [];
  final apiService = ApiService();

  List<Friend> get friends =>
      _friends.where((element) => element.isFriend).toList();
  List<Friend> get requests =>
      _friends.where((element) => element.isReceiving).toList();
  List<Friend> get receives =>
      _friends.where((element) => element.isRequested).toList();
  List<Friend> get suggestions => _suggestions;

  Future<void> fetchFriends() async {
    final friends = await apiService.getFriends();
    _friends = friends.asMap().entries.map<Friend>((entry) {
      int index = entry.key;
      var friend = entry.value;
      return processData(friend,
          index); // Assuming processDataWithIndex takes both friend and index.
    }).toList();
    final suggestions = await apiService.getSuggestedFriends();
    _suggestions = suggestions.asMap().entries.map<Friend>((entry) {
      int index = entry.key;
      var friend = entry.value;
      return processSuggestions(friend,
          index); // Assuming processDataWithIndex takes both friend and index.
    }).toList();
    notifyListeners();
  }

  Future<void> addFriend(id, int friendId) async {
    final index = _suggestions.indexWhere((element) => element.id == id);

    if (index != -1) {
      final friend = _suggestions[index];
      final friendshipId = await apiService.addFriend(friendId);
      _friends.insert(
          0,
          Friend(
              friendName: friend.friendName,
              friendImage: friend.friendImage,
              friendStatus: friend.friendStatus,
              friendId: friend.friendId,
              mutuals: friend.mutuals,
              isFriend: false,
              isRequested: true,
              isReceiving: false,
              isSuggested: false,
              friendSince: DateTime.now(),
              friendshipId: friendshipId,
              id: friendshipId));
      _suggestions.removeAt(index);
      notifyListeners();
      _friends[index].isRequested = true;
      _friends[index].isReceiving = false;
      _friends[index].isFriend = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriend(id, int friendshipId) async {
    final index = _friends.indexWhere((element) => element.id == id);
    if (index != -1) {
      await apiService.acceptFriend(friendshipId);
      _friends[index].isFriend = true;
      _friends[index].isReceiving = false;
      _friends[index].isRequested = false;
      notifyListeners();
    }
  }

  Future<void> removeFriendOrRequest(id, int friendshipId) async {
    final index = _friends.indexWhere((element) => element.id == id);
    if (index != -1) {
      await apiService.removeFriend(friendshipId);
      _friends.removeAt(index);
      notifyListeners();
    }
  }
}

Friend processData(Map<String, dynamic> data, index) {
  return Friend(
      friendName: data['others']
          ? data['friend']['username']
          : data['user']['username'],
      friendImage: 'https://via.placeholder.com/150',
      friendStatus: data['status'] ? 'Friend' : 'Not Friend',
      friendId: data['friend']['id'],
      mutuals: data['mutual_friends'],
      isFriend: data['status'],
      isRequested: data['others'] && !data['status'],
      isReceiving: !data['others'] && !data['status'],
      isSuggested: false,
      friendSince: DateTime.parse(data['created_at']),
      friendshipId: data['id'] ?? -1,
      id: data['id'] ?? -index);
}

Friend processSuggestions(Map<String, dynamic> data, index) {
  return Friend(
      friendName: data['username'],
      friendImage: 'https://via.placeholder.com/150',
      friendStatus: 'Suggested',
      friendId: data['id'],
      mutuals: data['mutual_friends'],
      isFriend: false,
      isRequested: false,
      isReceiving: false,
      isSuggested: true,
      friendSince: DateTime.now(),
      friendshipId: -1,
      id: -index);
}
