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
  });

  final String postImage;
  final String postText;
  final DateTime postTime;
  final String postUserImage;
  final String postUserName;
  final String postTitle;
  final String postSubtitle;
  final DataSource events;
  final int likes;
  final int id;
  final bool isLiked;
  final bool belong;
}

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  final apiService = ApiService();

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    // final response = await apiService.getPosts();
    // _posts = response.map<Post>((p) => processData(p)).toList();
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

  void editPost(Post updatedPost) {
    final index = _posts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      // Optimistically update the UI
      final oldPost = _posts[index];
      _posts[index] = updatedPost;
      notifyListeners();

      // Call API to sync with backend
      apiService.updatePost(updatedPost).catchError((error) {
        // Rollback to old state if the API call fails
        _posts[index] = oldPost;
        notifyListeners();
      });
    }
  }

  void deletePost(String postId) {
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
            ));
    if (post.id != -1) {
      // Optimistically remove from the UI
      _posts.remove(post);
      notifyListeners();

      // Call API to sync with backend
      apiService.deletePost(postId).catchError((error) {
        // Rollback if the API call fails
        _posts.add(post);
        notifyListeners();
      });
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
  print(meetingCollection);
  return meetingCollection;
}

Post processData(Map<String, dynamic> data) {
  print(data);
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
      belong: data['is_belong_to_user']);
}
