library event_calendar;

import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/calendar_model.dart';
import '../../provider/calender_time_provider.dart';
import '../../services/django/api_service.dart';
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
String currentCalendar = '';

class Item {
  Item(this.name, this.id);
  String name;
  String id;
  @override
  String toString() => name;
}

class CalenderPage extends StatefulWidget {
  String current = '';
  CalenderPage({Key? key, this.current = ''}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late List<String> eventNameCollection;
  late List<Item> _items = <Item>[];
  List<Meeting> appointments = <Meeting>[];
  CalendarController calendarController = CalendarController();
  bool valid = false;
  bool isLoading = true;

  @override
  void initState() {
    getInformations();
    _selectedAppointment = null;
    _selectedColorIndex = Colors.black;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    valid = _items.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTimeProvider =
        Provider.of<SelectedTimeChangeProvider>(context, listen: false);
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 720,
        defaultPanelState: PanelState.OPEN,
        isDraggable: false,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        panel: Padding(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          child: !isLoading
              ? Column(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                  color:
                                      const Color.fromARGB(255, 147, 139, 174),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(
                                    child: Text(
                                      "Calendar",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _items.isNotEmpty
                        ? CustomDropdown<Item>(
                            hintText: 'Select job role',
                            items: _items,
                            initialItem: _items.firstWhere(
                              (item) => item.id == currentCalendar,
                              orElse: () => _items[
                                  0], // Optionally, handle the case where no item is found
                            ),
                            onChanged: (value) {
                              setState(() {
                                currentCalendar = value!.id;
                              });
                              getMeetingDetails();
                            },
                          )
                        : const SizedBox.shrink(),
                    !_items.isNotEmpty || !valid
                        ? Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Column(
                                children: [
                                  Text(
                                    valid
                                        ? 'No calendar found'
                                        : 'No events found ',
                                    style: GoogleFonts.getFont('Nunito',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${_items.firstWhere((element) => element.id == currentCalendar).name} ',
                                    style: GoogleFonts.getFont('Nunito',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: const Color.fromARGB(
                                            255, 147, 139, 174)),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    valid
                                        ? 'Please create a calendar to continue'
                                        : 'Please add events to continue',
                                    style: GoogleFonts.getFont('Nunito',
                                        fontSize: 20, color: Colors.black),
                                  )
                                ],
                              ),
                              Lottie.asset(
                                valid
                                    ? 'assets/animations/invalid_calendar.json'
                                    : 'assets/animations/invalid_activity.json',
                                width:
                                    MediaQuery.of(context).size.height * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                fit: BoxFit.fill,
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                    _items.isNotEmpty && valid
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(22)),
                            child: DatePicker(
                              DateTime.now(),
                              initialSelectedDate: DateTime.now(),
                              width: 60,
                              selectionColor:
                                  const Color.fromARGB(255, 147, 139, 174),
                              dateTextStyle: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 26),
                              onDateChange: (date) {
                                selectedTimeProvider.setSelectedDate(date);
                                calendarController.displayDate = date;
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    _items.isNotEmpty && valid
                        ? Expanded(
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
                                  allowAppointmentResize: true,
                                  allowDragAndDrop: true,
                                  timeSlotViewSettings:
                                      const TimeSlotViewSettings(
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
                                    final Meeting meeting =
                                        details.appointments.first;
                                    if (meeting.isAllDay) {
                                      return Container(
                                        // color: meeting.background.withOpacity(0.7),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color:
                                              meeting.background.withOpacity(1),
                                        ),
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          meeting.eventName,
                                          style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 15),
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
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(5)),
                                            color: meeting.background
                                                .withOpacity(1),
                                          ),
                                          child: SingleChildScrollView(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                meeting.eventName,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 3,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: details
                                                              .bounds.height *
                                                          0.008)),
                                              Text(
                                                'Time: ${DateFormat('hh:mm a').format(meeting.from)} - ${DateFormat('hh:mm a').format(meeting.to)}',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )),
                                        ),
                                        Container(
                                          height: details.bounds.height * 0.55,
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 5, 3, 2),
                                          color: meeting.background
                                              .withOpacity(0.7),
                                          alignment: Alignment.topLeft,
                                          child: SingleChildScrollView(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                meeting.description!,
                                                style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              )
                                            ],
                                          )),
                                        ),
                                        Container(
                                          height: details.bounds.height * 0.1,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                            color: meeting.background
                                                .withOpacity(1),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  initialDisplayDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      0,
                                      0,
                                      0),
                                  monthViewSettings: const MonthViewSettings(
                                      appointmentDisplayMode:
                                          MonthAppointmentDisplayMode
                                              .appointment),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
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

  Future<void> getInformations() async {
    final List<dynamic> calendarNames = await apiService.getCalendars();
    setState(() {
      _items = calendarNames
          .map((event) => Item(event['name'], event['id']))
          .toList();
    });
    setState(() {
      currentCalendar = widget.current != ''
          ? widget.current
          : _items.isNotEmpty
              ? _items[0].id
              : '';
    });
    await getMeetingDetails();
    await Future.delayed(
        const Duration(milliseconds: 300), () => 'Fake async result');
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getMeetingDetails() async {
    chosenList = await apiService.getChosenList(currentCalendar);
    if (chosenList.isEmpty) {
      setState(() {
        valid = false;
      });
      return;
    }
    _selectedActivity = chosenList.isNotEmpty ? chosenList[0]['id'] : 1;
    final backendCalendar = await apiService.getCalendar(currentCalendar);
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
    setState(() {
      appointments = meetingCollection;
      _events = DataSource(appointments);
      valid = true;
    });
  }
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
  const Color(0xFF6a040f),
  const Color(0xFF5E60CE),
  const Color(0xFF6930C3),
  const Color(0xFF48BFE3),
  const Color(0xFF1a759f),
  const Color(0xFF3a0ca3),
  const Color(0xFF354f52),
  const Color(0xFF1f7a8c),
  const Color(0xFF2a9d8f),
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
