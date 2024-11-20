import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/django/api_service.dart';
import '../provider/calender_time_provider.dart';

class TimeCard extends StatefulWidget {
  final ApiService apiService = ApiService();
  final List tasksList6am;
  // ignore: non_constant_identifier_names
  final String time_for_card;
  final Color dividerColor;
  final int index;
  final int duration;
  final void Function() onTaskDelete;
  final void Function(
    Map<String, dynamic> task,
  ) addTask;
  TimeCard({
    super.key,
    required this.addTask,
    required this.tasksList6am,
    // ignore: non_constant_identifier_names
    required this.time_for_card,
    required this.index,
    required this.dividerColor,
    required this.onTaskDelete,
    required this.duration,
  });

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> pickTime(start, initial) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      return time.format(context);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior:
          Clip.none, // Allows the task list to overflow the Stack bounds
      children: [
        Row(
          children: [
            VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: widget.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.time_for_card,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                // Placeholder for where the task list will be
                const SizedBox(height: 120, width: 100),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: widget.dividerColor),
                  ),
                  child: GestureDetector(
                      onTap: (() {
                        addTask(widget.index);
                      }),
                      child: Icon(
                        CupertinoIcons.add,
                        color: widget.dividerColor,
                      )),
                )
              ],
            ),
          ],
        ),
        // Positioned(
        //   left: 2, // Adjust this value for fine-tuning overlap
        //   top: 30,
        //   child: task_list(),
        // ),
      ],
    );
  }

  // Widget task_list() {
  //   for (int i in widget.tasks.keys) {
  //     if (widget.index == i) {
  //       return Consumer<SelectedTimeChangeProvider>(
  //           builder: (context, value, child) {
  //         return Container(
  //           height: 120,
  //           child: ConstrainedBox(
  //             constraints: BoxConstraints(
  //                 maxWidth: 300), // Restrict the width of the ListView
  //             child: ListView.builder(
  //               padding: EdgeInsets.zero,
  //               itemCount: widget.tasks[i].length,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       onTaskTap(index, widget.tasks);
  //                     },
  //                     child: Container(
  //                       width: 100, // Fixed width for the inner container
  //                       decoration: BoxDecoration(
  //                         color: widget.dividerColor,
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Center(
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             widget.tasks[i][index]['task'],
  //                             style: GoogleFonts.poppins(),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         );
  //       });
  //     }
  //   }
  //   return Container(
  //     height: 120,
  //     width: 50,
  //   );
  // }

  Future addTask(int TappedIndex) => showDialog(
      context: context,
      builder: (context) {
        int hour = widget.time_for_card.contains("pm")
            ? int.parse(widget.time_for_card.split(" ")[0]) + 12
            : int.parse(widget.time_for_card.split(" ")[0]);
        TimeOfDay initial = TimeOfDay(hour: hour, minute: 0);
        String localStartDate = '';
        String localEndDate = '';
        TextEditingController addTaskbtn = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text("Add Activity"),
              content: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns children to the start
                mainAxisSize: MainAxisSize.min, // Prevents overflow
                children: [
                  const Text(
                    "Enter Details", // Optional label
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height: 8), // Adds spacing between Text and TextField
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter Title",
                      border: OutlineInputBorder(), // Adds a visible border
                    ),
                    controller: addTaskbtn,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      String? time = await pickTime(true, initial);
                      if (time != null) {
                        setDialogState(() {
                          localStartDate = time;
                        });
                      }
                    },
                    child: localStartDate == ''
                        ? const Text('Select Start Time')
                        : Text(localStartDate),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      String? time = await pickTime(false, initial);
                      if (time != null) {
                        setDialogState(() {
                          localEndDate = time;
                        });
                      }
                    },
                    child: localEndDate == ''
                        ? const Text('Select End Time')
                        : Text(localEndDate),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (addTaskbtn.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Task name cannot be empty")),
                      );
                      return;
                    }
                    if (localStartDate.isEmpty || localEndDate.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Start and end dates must be selected")),
                      );
                      return;
                    }
                    print(localStartDate);
                    print(localEndDate);
                    if (localStartDate.compareTo(localEndDate) > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Start date cannot be after end date")),
                      );
                      return;
                    }

                    try {
                      setState(() {
                        widget.addTask({
                          'task': addTaskbtn.text,
                          'startDate': localStartDate,
                          'endDate': localEndDate,
                        });
                      });
                    } on NoSuchMethodError {
                    } catch (e) {
                      // Handle other exceptions if necessary
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      });
}
