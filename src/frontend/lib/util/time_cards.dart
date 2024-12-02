import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/django/api_service.dart';

class TimeCard extends StatefulWidget {
  final ApiService apiService = ApiService();
  final List tasksList6am;
  // ignore: non_constant_identifier_names
  final String time_for_card;
  final Color dividerColor;
  final int index;
  final int duration;
  final List<IconData> icons;
  final Color color;
  final bool hasEvent;
  TimeCard({
    super.key,
    required this.tasksList6am,
    // ignore: non_constant_identifier_names
    required this.time_for_card,
    required this.index,
    required this.dividerColor,
    required this.duration,
    required this.icons,
    required this.color,
    required this.hasEvent,
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
                if (widget.hasEvent)
                  Column(
                    children: widget.icons
                        .map((icon) => Icon(
                              icon,
                              color: widget.color,
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 100, width: 20),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
