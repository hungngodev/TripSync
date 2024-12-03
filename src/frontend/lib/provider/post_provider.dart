import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../services/django/api_service.dart';

class Post {
  Post({
    required this.postImage,
    required this.postText,
    required this.postTime,
    required this.postUserImage,
    required this.postUserName,
    required this.postTitle,
    required this.postSubtitle,
    required this.events,
    required this.likes,
    required this.id,
    required this.isLiked,
    required this.belong,
    required this.calendarName,
    required this.calendarId,
    required this.isFriend,
    required this.receiveRequest,
    required this.sendRequest,
    required this.friendshipId,
    required this.authorId,
  });

  String postImage;
  String postText;
  DateTime postTime;
  String postUserImage;
  String postUserName;
  String postTitle;
  String postSubtitle;
  DataSource events;
  int likes;
  int id;
  bool isLiked;
  bool belong;
  String calendarName;
  int calendarId;
  bool isEditing = false;
  bool isFriend;
  bool sendRequest;
  bool receiveRequest;
  int friendshipId;
  int authorId;
}

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  final apiService = ApiService();

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    final response = await apiService.getPosts();
    _posts = response.map<Post>((p) => processData(p)).toList();
    notifyListeners();
  }

  Future<void> addPost(dynamic post) async {
    // Optimistically update the UI
    dynamic response = await apiService.addPost({
      'title': post['title'],
      'content': post['content'],
      'calendar': post['calendar'],
    });
    _posts.insert(0, processData(response));
    notifyListeners();
  }

  void beginEdit(postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isEditing = true;
      notifyListeners();
    }
  }

  void stopEdit(postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isEditing = false;
      notifyListeners();
    }
  }

  Future<void> changeCalendarEdit(postId, calendarId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final newEvent = await apiService.getCalendar(calendarId);
      _posts[index].events = DataSource(transform(newEvent));
      notifyListeners();
    }
  }

  Future<void> editPost(postId, newContent, newCalendarName) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      // Optimistically update the UI
      await apiService.editPost(postId, newContent);
      _posts[index].postTitle = newContent['title'];
      _posts[index].postSubtitle = newContent['content'];
      _posts[index].calendarName = newCalendarName;
      _posts[index].calendarId = int.parse(newContent['calendar']);
      notifyListeners();
    }
  }

  Future<void> deletePost(int postId) async {
    final post = _posts.firstWhere((p) => p.id == postId,
        orElse: () => Post(
            postImage: '',
            postText: '',
            postTime: DateTime.now(),
            postUserImage: '',
            postUserName: '',
            postTitle: '',
            postSubtitle: '',
            events: DataSource([]),
            likes: 0,
            id: -1,
            isLiked: false,
            belong: false,
            calendarName: '',
            calendarId: 0,
            sendRequest: false,
            receiveRequest: false,
            friendshipId: 0,
            authorId: 0,
            isFriend: false));
    if (post.id != -1) {
      await apiService.deletePost(postId);
      _posts.remove(post);
      notifyListeners();
    }
  }

  Future<void> toggleLike(int id, bool like) async {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      // Optimistically update the UI
      await apiService.toggleLike(id, like);
      final oldPost = _posts[index];
      _posts[index] = Post(
          postImage: oldPost.postImage,
          postText: oldPost.postText,
          postTime: oldPost.postTime,
          postUserImage: oldPost.postUserImage,
          postUserName: oldPost.postUserName,
          postTitle: oldPost.postTitle,
          postSubtitle: oldPost.postSubtitle,
          events: oldPost.events,
          likes: oldPost.likes + (like ? 1 : -1),
          id: oldPost.id,
          isLiked: like ? true : false,
          belong: oldPost.belong,
          calendarName: oldPost.calendarName,
          receiveRequest: oldPost.receiveRequest,
          sendRequest: oldPost.sendRequest,
          calendarId: oldPost.calendarId,
          friendshipId: oldPost.friendshipId,
          authorId: oldPost.authorId,
          isFriend: oldPost.isFriend);
      notifyListeners();
    }
  }

  Future<void> addFriend(postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];
      if (oldPost.friendshipId != -1) {
        return;
      }

      // Optimistically update the UI
      int friendshipId = await apiService.addFriend(oldPost.authorId);
      for (var post in _posts.where((p) => p.authorId == oldPost.authorId)) {
        post.isFriend = false;
        post.sendRequest = true;
        post.receiveRequest = false;
        post.friendshipId = friendshipId;
      }
      notifyListeners();
    }
  }

  Future<void> acceptFriend(postId, friendshipId) async {
    print(friendshipId);
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];

      // Optimistically update the UI
      await apiService.acceptFriend(friendshipId);
      for (var post in _posts.where((p) => p.authorId == oldPost.authorId)) {
        post.isFriend = true;
        post.sendRequest = false;
        post.receiveRequest = false;
        post.friendshipId = oldPost.friendshipId;
      }
      notifyListeners();
    }
  }

  Future<void> removeFriend(postId, friendshipId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];
      if (oldPost.friendshipId == -1) {
        return;
      }
      // Optimistically update the UI
      await apiService.removeFriend(friendshipId);

      for (var post in _posts.where((p) => p.authorId == oldPost.authorId)) {
        post.isFriend = false;
        post.sendRequest = false;
        post.receiveRequest = false;
        post.friendshipId = -1;
      }
      notifyListeners();
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  @override
  String getEndTimeZone(int index) => appointments![index].endTimeZone;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
}

class Meeting {
  Meeting(
      {required this.from,
      required this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = '',
      this.subject = '',
      this.url = '',
      this.activity,
      required this.id});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
  final String subject;
  final String url;
  final dynamic activity;
  final int id;
}

List<Meeting> transform(List<dynamic> backendCalendar) {
  final List<Meeting> meetingCollection = backendCalendar
      .map((event) => Meeting(
            from: DateTime.parse(event['start_date']),
            to: DateTime.parse(event['end_date']),
            background: Color(int.parse('0x${event['color']}')),
            startTimeZone: event['startTimeZone'],
            endTimeZone: event['endTimeZone'],
            description: event['description'],
            eventName: event['title'],
            subject: '',
            url: 'assets/images/1.jpg',
            activity: (event['activity']['id']),
            id: event['id'],
            isAllDay: event['isAllDay'],
          ))
      .toList();
  return meetingCollection;
}

Post processData(Map<String, dynamic> data) {
  print(data['is_friend']);
  print(data['is_send_request']);
  print(data['is_receive_request']);
  print(data['friendship_id']);
  return Post(
      postImage:
          'https://img.freepik.com/free-photo/beautiful-view-sunset-sea_23-2148019892.jpg?t=st=1733194360~exp=1733197960~hmac=ebbb218f09d5846d04de98d27d0b3f62f69103b3d16e3542f81190b86ad05d6e&w=1060',
      postText: '',
      postTime: DateTime.parse(data['date_posted']),
      postUserImage:
          'https://img.freepik.com/free-photo/beautiful-view-sunset-sea_23-2148019892.jpg?t=st=1733194360~exp=1733197960~hmac=ebbb218f09d5846d04de98d27d0b3f62f69103b3d16e3542f81190b86ad05d6e&w=1060',
      postUserName: data['author']['username'],
      postTitle: data['title'],
      postSubtitle: data['content'],
      events: DataSource(transform(data['events'])),
      likes: data['likes_count'],
      id: data['id'],
      isLiked: data['is_liked_by_user'],
      belong: data['is_belong_to_user'],
      calendarName: data['calendar']['name'],
      calendarId: data['calendar']['id'],
      sendRequest: data['is_send_request'],
      receiveRequest: data['is_receive_request'],
      friendshipId: data['friendship_id'] ?? -1,
      authorId: data['author']['id'],
      isFriend: data['is_friend']);
}
