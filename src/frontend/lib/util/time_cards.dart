import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/django/api_service.dart';
import '../provider/calender_time_provider.dart';

class TimeCard extends StatefulWidget {
  final Map tasks;
  final ApiService apiService = ApiService();
  final List tasksList6am;
  // ignore: non_constant_identifier_names
  final String time_for_card;
  final Color dividerColor;
  final int index;
  final int duration;
  final void Function() onTaskDelete;
  TimeCard({
    super.key,
    required this.tasks,
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
  late TextEditingController addTaskbtn;
  late ApiService apiService;
  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    super.initState();
    addTaskbtn = TextEditingController();
    apiService = ApiService();
    startDate = TimeOfDay.now().format(context);
    endDate = TimeOfDay.now().format(context);
  }

  @override
  void dispose() {
    super.dispose();
    addTaskbtn.dispose();
  }

  void pickTime(start) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
      setState(() {
        if (start) {
          startDate = time.format(context);
        } else {
          endDate = time.format(context);
        }
      });
    }
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
        Positioned(
          left: 2, // Adjust this value for fine-tuning overlap
          top: 30,
          child: task_list(),
        ),
      ],
    );
  }

  Widget task_list() {
    for (int i in widget.tasks.keys) {
      if (widget.index == i) {
        return Consumer<SelectedTimeChangeProvider>(
            builder: (context, value, child) {
          return Container(
            height: 120,
            width: widget.tasks[i].isNotEmpty ? 100 : 50,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.tasks[i].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        onTaskTap(index, widget.tasks);
                      },
                      child: Container(
                        width: 300,
                        height: 40,
                        decoration: BoxDecoration(
                            color: widget.dividerColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.tasks[i][index]['task'],
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
      }
    }
    return Container(
      height: 120,
      width: 50,
    );
  }

  Future addTask(int TappedIndex) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Add Activity"),
            content: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns children to the start
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
                ElevatedButton(
                  onPressed: () => {
                    pickTime(true),
                  },
                  child: Text(
                    startDate,
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    try {
                      setState(() {
                        widget.tasks[TappedIndex].add({
                          'task': addTaskbtn.text,
                          'duration': 100,
                        });
                      });
                    } on NoSuchMethodError {
                      setState(() {
                        widget.tasks[TappedIndex] = [
                          {
                            'task': addTaskbtn.text,
                            'duration': 100,
                          }
                        ];
                      });
                    } catch (e) {
                      // Handle other exceptions if necessary
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style: GoogleFonts.poppins(color: Colors.black),
                  )),
            ],
          ));

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
                    widget.tasks[widget.index]?.removeAt(index);
                    if (widget.tasks[widget.index]?.isEmpty ?? false) {
                      widget.tasks.remove(widget.index);
                    }
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
