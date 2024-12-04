import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/calendar_model.dart';
import '../services/django/api_service.dart';

class ViewAllPage extends StatefulWidget {
  final ApiService apiService = ApiService();
  final VoidCallback onBack;

  ViewAllPage({required this.onBack, Key? key}) : super(key: key);
  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  ApiService apiService = ApiService();

  List<dynamic> calendars = [];

  @override
  void initState() {
    super.initState();
    getCalendars();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCalendars() async {
    final response = await apiService.getDetailedCalendars();
    if (response != null) {
      setState(() {
        calendars = response.map((c) => processData(c)).toList();
      });
      print(calendars);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: widget.onBack,
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: calendars.map((calendar) {
              return Column(
                children: [
                  ListTile(
                    title: Text(calendar['name'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                    leading: const Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 147, 139, 174)),
                  ),
                  SizedBox(
                    height: 300,
                    child: SfCalendar(
                      allowAppointmentResize: true,
                      allowDragAndDrop: true,
                      view: CalendarView.schedule,
                      scheduleViewSettings: const ScheduleViewSettings(
                          hideEmptyScheduleWeek: true,
                          monthHeaderSettings: MonthHeaderSettings(
                            height: 0,
                          )),
                      allowViewNavigation: true,
                      todayHighlightColor: Colors.blue,
                      showNavigationArrow: true,
                      firstDayOfWeek: 1,
                      showCurrentTimeIndicator: true,
                      dataSource: calendar['events'], // Use dynamic data source
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ],
              );
            }).toList(),
          ),
        ));
  }
}

Map<String, dynamic> processData(Map<String, dynamic> data) {
  return {
    'name': data['name'],
    'id': data['id'],
    'created_at': data['created_at'],
    'events': DataSource(transform(data['events'])),
  };
}
