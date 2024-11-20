import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../pages/home/today_page.dart';
import '../provider/calender_time_provider.dart';
import '../provider/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TablePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarSubPage(key: UniqueKey(), title: 'Flutter Demo Home Page');
  }
}

class CalendarSubPage extends StatefulWidget {
  CalendarSubPage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarSubPage> {
  final CalendarController _controller = CalendarController();
  Color? _headerColor, _viewHeaderColor, _calendarColor;
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.month,
        CalendarView.timelineDay,
        CalendarView.timelineWeek,
        CalendarView.timelineWorkWeek
      ],
      controller: _controller,
      onTap: calendarTapped,
      monthViewSettings: const MonthViewSettings(
          navigationDirection: MonthNavigationDirection.vertical),
      view: CalendarView.day,
      todayHighlightColor: Colors.blue,
      cellBorderColor: Colors.cyanAccent,
      showNavigationArrow: true,
      firstDayOfWeek: 1,
      headerStyle: const CalendarHeaderStyle(
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      viewHeaderStyle: const ViewHeaderStyle(
        dayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
      showCurrentTimeIndicator: true,
      //initialDisplayDate: DateTime(2021, 03, 01, 08, 30),
      //initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
      dataSource: MeetingDataSource(getAppointments()),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
