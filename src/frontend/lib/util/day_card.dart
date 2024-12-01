import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './time_cards.dart';

class DayCard extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime endDate;
  final Color cardColor;
  final Color dividerColor;
  final String name;
  DayCard({
    Key? key,
    required this.selectedDate,
    required this.cardColor,
    required this.dividerColor,
    required this.name,
    required this.endDate,
  }) : super(key: key);

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  TextEditingController addTaskbtn = TextEditingController();

  List<String> tasksList6am = [];
  List<String> timeList = [
    "5:00",
    "6:00",
    "7:00",
    "8:00",
    "9:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00",
    "24:00",
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 185,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                      widget.name.split(' ').length,
                      (index) => Text(
                        widget.name.split(' ')[index],
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${DateTime.now().difference(widget.selectedDate).inDays} days ago",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 250,
                child: Stack(
                    clipBehavior: Clip
                        .none, // Allows the task list to overflow the Stack bounds
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: timeList.length,
                          itemBuilder: (context, index) {
                            return TimeCard(
                              icon: Icons.house,
                              color: iconColors[index % iconColors.length],
                              tasksList6am: tasksList6am,
                              time_for_card: timeList[index],
                              index: index,
                              dividerColor: widget.dividerColor,
                              duration: 100,
                            );
                          }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<Color> iconColors = [
  Color(0x00f5d4),
  Color(0x00bbf9),
  Color(0xfee440),
  Color(0xf15bb5),
  Color(0x9b5de5),
  Color(0xff0054),
  Color(0x8ac926),
];
