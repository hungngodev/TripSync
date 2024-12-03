import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TaskCard extends StatelessWidget {
  Color clr;
  String title = "You have a trip at Amhert Museum";
  String start = "3:00 PM";
  String end = "5:00 PM";
  String duration = "2 Hour";
  String description = "You have a trip at Amhert Museum";
  String source = 'My Calendar';
  String date;
  TaskCard(
      {super.key,
      required this.clr,
      required this.title,
      required this.start,
      required this.end,
      required this.duration,
      required this.description,
      required this.date,
      required this.source});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            // rgba(173,155,140,255)
            color: clr,
            borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        source,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    date,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        start,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        "Start",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 75,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child: Text(
                        duration,
                        style: GoogleFonts.poppins(
                          color: clr,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        end,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        "End",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
