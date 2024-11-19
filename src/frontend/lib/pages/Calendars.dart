import 'package:flutter/material.dart';
import 'package:flutter_application/pages/Home.dart';
import 'package:flutter_application/pages/createcalendar.dart';

class Calendars extends StatefulWidget {
  const Calendars({super.key});

  @override
  State<Calendars> createState() => _CalendarsState();
}

class _CalendarsState extends State<Calendars> {
  // ignore: non_constant_identifier_names
  OpenHomePage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const HomePage()));
  }

  openCreateCalendarPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Createcalendar()));
  }

  final List<String> activities = ["Yoga", "Meeting", "Lunch", "Workout", "Study"];
  final Map<DateTime, List<String>> calendarActivities = {};

  void addActivityToDate(DateTime date, String activity) {
    setState(() {
      calendarActivities.putIfAbsent(date, () => []);
      calendarActivities[date]!.add(activity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    DateTime selectedDate = today;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar with Activities"),
        backgroundColor: Colors.teal,
      ),
      body: Row(
        children: [
          // Sidebar for draggable activities
          Container(
            width: 200,
            color: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Activities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return Draggable<String>(
                        data: activities[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: Chip(
                            label: Text(activities[index]),
                            backgroundColor: Colors.teal,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        child: ListTile(
                          title: Text(activities[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Calendar area
          Expanded(
            child: Column(
              children: [
                CalendarWidget(
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: DragTarget<String>(
                    onAccept: (activity) {
                      addActivityToDate(selectedDate, activity);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.teal),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Activities on ${selectedDate.toLocal().toShortDateString()}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    calendarActivities[selectedDate]?.length ??
                                        0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        calendarActivities[selectedDate]![index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const CalendarWidget({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final daysInWeek = List.generate(7, (index) {
      return today.add(Duration(days: index - today.weekday + 1));
    });

    return Container(
      height: 100,
      color: Colors.grey.shade100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysInWeek.length,
        itemBuilder: (context, index) {
          final date = daysInWeek[index];
          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.day}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                        [date.weekday - 1],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extension for formatting the date as a short string
extension DateFormatting on DateTime {
  String toShortDateString() {
    return "${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }
}