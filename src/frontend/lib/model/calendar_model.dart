import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
