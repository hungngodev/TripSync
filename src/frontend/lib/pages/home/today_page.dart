import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../provider/time_provider.dart';
import '../../services/django/api_service.dart';
import '../../util/task_cards.dart';
import './calender_page.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<dynamic> meeting = [];
  final ApiService apiService = ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timeProvider.setTime();
    });
    fetchCalendar();
  }

  Future<void> fetchCalendar() async {
    final response = await ApiService().getCalendar();
    if (response != null) {
      setState(() {
        meeting = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      maxHeight: 350,
      defaultPanelState: PanelState.OPEN,
      isDraggable: true,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      panel: Padding(
        padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Activities",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 45,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child: Text(
                        "Reminders",
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: meeting.map((task) {
                    print(task);
                    DateTime start = DateTime.parse(task['start_date']);
                    DateTime end = DateTime.parse(task['end_date']);
                    Duration duration = end.difference(start);
                    if (start.day != DateTime.now().day ||
                        start.isAfter(DateTime.now())) {
                      return const SizedBox();
                    }
                    return TaskCard(
                      clr: Color(int.parse('0x${task['color']}')),
                      title: task['title'], // Pass title
                      start: DateFormat('h:mm a').format(start.toLocal()),
                      end: DateFormat('h:mm a').format(end.toLocal()),
                      duration: '${duration.inHours} hours', // Pass duration
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          // rgba(153,154,157,255)
          color: const Color.fromARGB(255, 186, 187, 190),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 147, 139, 174),
                                borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Today",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const CalenderPage()))).then((value) {
                                fetchCalendar();
                              })),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Calendar",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Tuesday",
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              direction: Axis.vertical,
                              spacing: -30,
                              children: [
                                Consumer<TimeProvider>(
                                    builder: (context, val, child) {
                                  return Text(
                                    val.time,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 70),
                                  );
                                }),

                                Consumer<TimeProvider>(
                                    builder: ((context, value, child) {
                                  return Text(
                                    value.month,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 70),
                                  );
                                }))
                                //   Text("OCT",
                                // style: GoogleFonts.poppins(
                                //   fontWeight: FontWeight.w500,
                                //   fontSize: 75
                                // ),
                                // ),
                              ]),
                        ],
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1:20 PM ",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "New York ",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "6:20 PM ",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "UK",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
