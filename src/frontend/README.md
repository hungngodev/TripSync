import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../model/calendar_model.dart';
import '../services/django/api_service.dart';

class ViewAllPage extends StatefulWidget {
final ApiService apiService = ApiService();
final VoidCallback onBack;
final navigateToCalendar;

ViewAllPage(
{required this.onBack, required this.navigateToCalendar, Key? key})
: super(key: key);
@override
State<ViewAllPage> createState() => \_ViewAllPageState();
}

class Calendar {
String id;
String name;
DataSource events;
DateTime createdAt;

Calendar(
{required this.id,
required this.name,
required this.events,
required this.createdAt});
}

class \_ViewAllPageState extends State<ViewAllPage> {
ApiService apiService = ApiService();

List<Calendar> calendars = [];

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
}
}

Future<void> deleteCalendar(String id) async {
final response = await apiService.deleteCalendar(id);
if (response) {
setState(() {
calendars.removeWhere((element) => element.id == id);
});
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
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ListTile(
title: Text(calendar.name,
style: const TextStyle(
color: Colors.black,
fontSize: 20,
fontWeight: FontWeight.w600,
)),
leading: const Icon(Icons.calendar_today,
color: Color.fromARGB(255, 147, 139, 174)),
trailing: Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
// IconButton(
// onPressed: () async {
// widget.navigateToCalendar(calendar.id, 2);
// },
// icon: const Icon(Icons.edit,
// color: Colors.orange, size: 30)),
// IconButton(
// onPressed: () async {
// await deleteCalendar(calendar.id);
// const snackBar = SnackBar(
// /// need to set following properties for best effect of awesome_snackbar_content
// elevation: 0,
// behavior: SnackBarBehavior.floating,
// backgroundColor: Colors.transparent,
// content: AwesomeSnackbarContent(
// title: '',
// message:
// 'Calendar has been successfully deleted!',

                        //           /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        //           contentType: ContentType.success,
                        //         ),
                        //       );

                        //       ScaffoldMessenger.of(context)
                        //         ..hideCurrentSnackBar()
                        //         ..showSnackBar(snackBar);
                        //     },
                        //     icon: const Icon(Icons.delete,
                        //         color: Colors.red, size: 30))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Created at: ${DateFormat('MMMM d, yyyy').format(calendar.createdAt)}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
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
                        dataSource: calendar.events // Use dynamic data source
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

Calendar processData(Map<String, dynamic> data) {
return Calendar(
id: data['id'],
name: data['name'],
events: DataSource(transform(data['events'])),
createdAt: DateTime.parse(data['created_at']));
}
