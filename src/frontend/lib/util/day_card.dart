import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './time_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/django/api_service.dart';
import '../provider/calender_time_provider.dart';
import 'package:intl/intl.dart';

class DayCard extends StatefulWidget {
  final DateTime selectedDate;
  final Color cardColor;
  final Color dividerColor;
  var tasks;
  DayCard({
    Key? key,
    required this.selectedDate,
    required this.cardColor,
    required this.dividerColor,
    required this.tasks,
  }) : super(key: key);

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  // var tasks = new Map();

  List<List<Map<String, dynamic>>> organizeTasks(List<dynamic> tasks) {
    // Helper function to parse a time string into a DateTime object
    DateTime parseTime(String time) {
      final format = DateFormat('h:mm a');
      return format.parse(time);
    }

    // Helper function to create a blank task
    Map<String, dynamic> createBlankTask(DateTime start, DateTime end) {
      return {
        'task': 'Blank',
        'startDate': start,
        'endDate': end,
      };
    }

    // Define the baseline range from 5 AM to 4 AM next day
    final DateTime baseStart = DateFormat('h:mm a').parse('5:00 AM');
    final DateTime baseEnd =
        DateFormat('h:mm a').parse('4:00 AM').add(Duration(days: 1));

    // Step 1: Create a deep copy of the tasks list
    List<Map<String, dynamic>> tasksCopy = tasks.map((task) {
      return {
        'task': task['task'],
        'startDate': parseTime(task['startDate']),
        'endDate': parseTime(task['endDate']),
      };
    }).toList();

    // Step 2: Sort the copied tasks by startDate, then by endDate
    tasksCopy.sort((a, b) {
      int startComparison = a['startDate'].compareTo(b['startDate']);
      if (startComparison != 0) return startComparison;
      return a['endDate'].compareTo(b['endDate']);
    });

    // Step 3: Organize tasks into rows
    List<List<Map<String, dynamic>>> rows = [];

    for (var task in tasksCopy) {
      bool placed = false;

      // Try to place the task in an existing row
      for (var row in rows) {
        if (row.every((existingTask) =>
            task['startDate'].isAfter(existingTask['endDate']) ||
            task['endDate'].isBefore(existingTask['startDate']))) {
          row.add(task);
          placed = true;
          break;
        }
      }

      // If no suitable row found, create a new row
      if (!placed) {
        rows.add([task]);
      }
    }

    // Step 4: Fill in blank intervals in each row
    for (var row in rows) {
      List<Map<String, dynamic>> filledRow = [];
      DateTime currentTime = baseStart;

      for (var task in row) {
        if (task['startDate'].isAfter(currentTime)) {
          filledRow.add(createBlankTask(currentTime, task['startDate']));
        }
        filledRow.add(task);
        currentTime = task['endDate'];
      }

      // Fill in the gap between the last task and the end of the day
      if (currentTime.isBefore(baseEnd)) {
        filledRow.add(createBlankTask(currentTime, baseEnd));
      }

      // Replace the row with the filled row
      row.clear();
      row.addAll(filledRow);
    }
    print(rows);
    return rows;
  }

  TextEditingController addTaskbtn = TextEditingController();

  List<String> tasksList6am = [];
  List<String> timeList = [
    "5 am",
    "6 am",
    "7 am",
    "8 am",
    "9 am",
    "10 am",
    "11 am",
    "12 pm",
    "1 pm",
    "2pm",
    "3pm",
    "4pm",
    "5pm",
    "6 pm",
    "7 pm",
    "8 pm",
    "9 pm",
    "10 pm",
    "11 pm",
    " 12 am",
    "1 am",
    "2 am",
    "3 am",
    "4 am"
  ];
  List<String> days = [
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
    "SATURDAY",
    "SUNDAY"
  ];
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

  @override
  Widget build(BuildContext context) {
    print(widget.tasks);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            // rgb()
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    days[widget.selectedDate.weekday - 1],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  Wrap(direction: Axis.vertical, spacing: -20, children: [
                    Text(
                      widget.selectedDate.day.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 50, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      months[widget.selectedDate.month - 1],
                      style: GoogleFonts.poppins(
                          fontSize: 50, fontWeight: FontWeight.w500),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 235,
                child: Stack(
                    clipBehavior: Clip
                        .none, // Allows the task list to overflow the Stack bounds
                    children: [
                      // ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: timeList.length,
                      //     itemBuilder: (context, index) {
                      //       return CalendarPage();
                      //       // return TimeCard(
                      //       //   tasksList6am: tasksList6am,
                      //       //   time_for_card: timeList[index],
                      //       //   index: index,
                      //       //   dividerColor: widget.dividerColor,
                      //       //   onTaskDelete: (() {
                      //       //     print("Task Deleted");
                      //       //   }),
                      //       //   addTask: (task) {
                      //       //     setState(() {
                      //       //       widget.tasks.add(task);
                      //       //     });
                      //       //   },
                      //       //   duration: 100,
                      //       // );
                      //     }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> task_list() {
    List<dynamic> tasks = [];
    for (int i in widget.tasks) {
      for (int j in widget.tasks[i].keys) {
        tasks.add(widget.tasks[i][j]);
      }
    }
    return tasks;
  }

  Future onTaskTap(int index, addTaskProvider) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Activity"),
            content: TextField(
              controller: addTaskbtn,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.tasks?.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
}
