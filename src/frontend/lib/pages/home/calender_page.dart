library event_calendar;

import 'dart:math';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../services/django/api_service.dart';

import '../../provider/calender_time_provider.dart';
import '../../util/mainColors.dart';

part '../../util/appointment-editor.dart';
part '../../util/color-picker.dart';
part '../../util/timezone-picker.dart';

List<Color> _colorCollection = colorCollection;
List<String> _colorNames = <String>[];
Color _selectedColorIndex = Colors.blue;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection = timeZoneCollection;
late DataSource _events;
Meeting? _selectedAppointment;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';
int _selectedActivity = 1;
late List<dynamic> chosenList;
final ApiService apiService = ApiService();
int _selectedMeeting = -1;

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  _CalenderPageState();

  late List<String> eventNameCollection;
  List<Meeting> appointments = <Meeting>[];
  CalendarController calendarController = CalendarController();

  @override
  void initState() {
    getMeetingDetails();
    _selectedAppointment = null;
    _selectedColorIndex = Colors.black;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTimeProvider =
        Provider.of<SelectedTimeChangeProvider>(context, listen: false);
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 750,
        defaultPanelState: PanelState.OPEN,
        isDraggable: false,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        panel: Padding(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (() => Navigator.pop(context)),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Today",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 147, 139, 174),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                "Calendar",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 110,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(22)),
                child: DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  width: 60,
                  selectionColor: const Color.fromARGB(255, 147, 139, 174),
                  dateTextStyle:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 26),
                  onDateChange: (date) {
                    selectedTimeProvider.setSelectedDate(date);
                    calendarController.displayDate = date;
                  },
                ),
              ),
              Expanded(
                child: Consumer<SelectedTimeChangeProvider>(
                  builder: (context, value, child) {
                    return SfCalendar(
                      view: CalendarView.day,
                      controller: calendarController,
                      allowedViews: const [
                        CalendarView.day,
                        CalendarView.week,
                        CalendarView.timelineWeek,
                        CalendarView.month
                      ],
                      onViewChanged: (ViewChangedDetails details) {
                        List<DateTime> dates = details.visibleDates;
                      },
                      allowAppointmentResize: true,
                      allowDragAndDrop: true,
                      timeSlotViewSettings: const TimeSlotViewSettings(
                        timeIntervalHeight: 80,
                      ),
                      allowViewNavigation: true,
                      todayHighlightColor: Colors.blue,
                      showNavigationArrow: true,
                      firstDayOfWeek: 1,
                      showCurrentTimeIndicator: true,
                      dataSource: _events,
                      onTap: onCalendarTapped,
                      appointmentBuilder: (BuildContext context,
                          CalendarAppointmentDetails details) {
                        final Meeting meeting = details.appointments.first;
                        if (meeting.isAllDay) {
                          return Container(
                            // color: meeting.background.withOpacity(0.7),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: meeting.background.withOpacity(1),
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              meeting.eventName,
                              style: GoogleFonts.nunito(
                                  color: Colors.white, fontSize: 15),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              height: details.bounds.height * 0.35,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                color: meeting.background.withOpacity(1),
                              ),
                              child: SingleChildScrollView(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meeting.eventName,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 3,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              details.bounds.height * 0.008)),
                                  Text(
                                    'Time: ${DateFormat('hh:mm a').format(meeting.from)} - ' +
                                        '${DateFormat('hh:mm a').format(meeting.to)}',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )
                                ],
                              )),
                            ),
                            Container(
                              height: details.bounds.height * 0.55,
                              padding: const EdgeInsets.fromLTRB(3, 5, 3, 2),
                              color: meeting.background.withOpacity(0.7),
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // details.bounds.height > 100
                                  //     ? Padding(
                                  //         padding: const EdgeInsets.symmetric(
                                  //             vertical: 5),
                                  //         child: Image(
                                  //             // image:
                                  //             //     ExactAssetImage(meeting.url),
                                  //             image: const NetworkImage(
                                  //                 'https://img.freepik.com/free-vector/world-tourism-day-concept-with-realistic-design_23-2147901978.jpg?t=st=1732163566~exp=1732167166~hmac=cf5af73b2ddc16523195d8ecb4bdbc46170ec1562437af88c1e3a8861259a0b4&w=2000'),
                                  //             fit: BoxFit.fitWidth,
                                  //             width: details.bounds.width,
                                  //             height:
                                  //                 details.bounds.height * 0.4),
                                  //       )
                                  //     : const SizedBox.shrink(),
                                  Text(
                                    meeting.description!,
                                    style: GoogleFonts.nunito(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              )),
                            ),
                            Container(
                              height: details.bounds.height * 0.1,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                color: meeting.background.withOpacity(1),
                              ),
                            ),
                          ],
                        );
                      },
                      initialDisplayDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day, 0, 0, 0),
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 153, 154, 157),
          ),
        ),
      ),
    );
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      final Random random = Random();
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = _colorCollection[random.nextInt(9)];
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      _selectedActivity = 1;
      _selectedMeeting = -1;
      if (calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments![0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _selectedColorIndex = meetingDetails.background;
          _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
              ? 0
              : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
          _selectedActivity = meetingDetails.activity;
          _selectedMeeting = meetingDetails.id;
        } else {
          final DateTime date = calendarTapDetails.date!;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const AppointmentEditor()),
        );
      }
    });
  }

  Future<void> getMeetingDetails() async {
    eventNameCollection = <String>[
      'General Meeting',
      'Plan Execution',
      'Project Plan',
      'Consulting',
      'Support',
      'Development Meeting',
      'Scrum',
      'Project Completion',
      'Release updates',
      'Performance Check',
    ];

    chosenList = await apiService.getChosenList();
    final Random random = Random();
    _selectedActivity = chosenList[0]['id'];
    print(_selectedActivity);
    final backendCalendar = await apiService.getCalendar();
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
    // final DateTime today = DateTime.now();
    // final Random random = Random();
    // for (int month = -1; month < 2; month++) {
    //   for (int day = -5; day < 5; day++) {
    //     for (int hour = 9; hour < 18; hour += 5) {
    //       meetingCollection.add(Meeting(
    //         from: today
    //             .add(Duration(days: (month * 30) + day))
    //             .add(Duration(hours: hour)),
    //         to: today
    //             .add(Duration(days: (month * 30) + day))
    //             .add(Duration(hours: hour + random.nextInt(4) + 2)),
    //         background: _colorCollection[random.nextInt(9)],
    //         startTimeZone: '',
    //         endTimeZone: '',
    //         description: 'loreum ipsum',
    //         isAllDay: false,
    //         eventName: eventNameCollection[random.nextInt(7)],
    //         subject: '',
    //         url: 'assets/images/1.jpg',
    //         activity: _selectedActivity,
    //         id: random.nextInt(1000),
    //       ));
    //     }
    //   }
    // }
    setState(() {
      appointments = meetingCollection;
      _events = DataSource(appointments);
    });
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

List<String> months = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC"
];
List<Color> cardColors = [
  maincolors.color1,
  maincolors.color2,
  maincolors.color3,
  maincolors.color4
];
List<Color> dividerColors = [
  maincolors.color1Dark,
  maincolors.color2Dark,
  maincolors.color3Dark,
  maincolors.color4Dark
];
final List<String> timeZoneCollection = [
  'Default Time',
  'AUS Central Standard Time',
  'AUS Eastern Standard Time',
  'Afghanistan Standard Time',
  'Alaskan Standard Time',
  'Arab Standard Time',
  'Arabian Standard Time',
  'Arabic Standard Time',
  'Argentina Standard Time',
  'Atlantic Standard Time',
  'Azerbaijan Standard Time',
  'Azores Standard Time',
  'Bahia Standard Time',
  'Bangladesh Standard Time',
  'Belarus Standard Time',
  'Canada Central Standard Time',
  'Cape Verde Standard Time',
  'Caucasus Standard Time',
  'Cen. Australia Standard Time',
  'Central America Standard Time',
  'Central Asia Standard Time',
  'Central Brazilian Standard Time',
  'Central Europe Standard Time',
  'Central European Standard Time',
  'Central Pacific Standard Time',
  'Central Standard Time',
  'China Standard Time',
  'Dateline Standard Time',
  'E. Africa Standard Time',
  'E. Australia Standard Time',
  'E. South America Standard Time',
  'Eastern Standard Time',
  'Egypt Standard Time',
  'Ekaterinburg Standard Time',
  'FLE Standard Time',
  'Fiji Standard Time',
  'GMT Standard Time',
  'GTB Standard Time',
  'Georgian Standard Time',
  'Greenland Standard Time',
  'Greenwich Standard Time',
  'Hawaiian Standard Time',
  'India Standard Time',
  'Iran Standard Time',
  'Israel Standard Time',
  'Jordan Standard Time',
  'Kaliningrad Standard Time',
  'Korea Standard Time',
  'Libya Standard Time',
  'Line Islands Standard Time',
  'Magadan Standard Time',
  'Mauritius Standard Time',
  'Middle East Standard Time',
  'Montevideo Standard Time',
  'Morocco Standard Time',
  'Mountain Standard Time',
  'Mountain Standard Time (Mexico)',
  'Myanmar Standard Time',
  'N. Central Asia Standard Time',
  'Namibia Standard Time',
  'Nepal Standard Time',
  'New Zealand Standard Time',
  'Newfoundland Standard Time',
  'North Asia East Standard Time',
  'North Asia Standard Time',
  'Pacific SA Standard Time',
  'Pacific Standard Time',
  'Pacific Standard Time (Mexico)',
  'Pakistan Standard Time',
  'Paraguay Standard Time',
  'Romance Standard Time',
  'Russia Time Zone 10',
  'Russia Time Zone 11',
  'Russia Time Zone 3',
  'Russian Standard Time',
  'SA Eastern Standard Time',
  'SA Pacific Standard Time',
  'SA Western Standard Time',
  'SE Asia Standard Time',
  'Samoa Standard Time',
  'Singapore Standard Time',
  'South Africa Standard Time',
  'Sri Lanka Standard Time',
  'Syria Standard Time',
  'Taipei Standard Time',
  'Tasmania Standard Time',
  'Tokyo Standard Time',
  'Tonga Standard Time',
  'Turkey Standard Time',
  'US Eastern Standard Time',
  'US Mountain Standard Time',
  'UTC',
  'UTC+12',
  'UTC-02',
  'UTC-11',
  'Ulaanbaatar Standard Time',
  'Venezuela Standard Time',
  'Vladivostok Standard Time',
  'W. Australia Standard Time',
  'W. Central Africa Standard Time',
  'W. Europe Standard Time',
  'West Asia Standard Time',
  'West Pacific Standard Time',
  'Yakutsk Standard Time',
];
final List<Color> colorCollection = [
  Color(0xFF6a040f),
  Color(0xFF5E60CE),
  Color(0xFF6930C3),
  Color(0xFF48BFE3),
  Color(0xFF1a759f),
  Color(0xFF3a0ca3),
  Color(0xFF354f52),
  Color(0xFF1f7a8c),
  Color(0xFF2a9d8f),
];
final List<String> eventNameCollection = [
  'General Meeting',
  'Plan Execution',
  'Project Plan',
  'Consulting',
  'Support',
  'Development Meeting',
  'Scrum',
  'Project Completion',
  'Release updates',
  'Performance Check',
];
