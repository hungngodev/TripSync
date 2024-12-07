import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home/calender_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/calender_time_provider.dart';
import '../../provider/time_provider.dart';
import './today_page.dart';
import 'outer_page.dart';

MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

class OuterPage extends StatelessWidget {
  bool showToday = true;
  String calendarId = '';
  OuterPage({this.showToday = true, this.calendarId = '', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => SelectedTimeChangeProvider())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 147, 139, 174),
          // title: Text(
          //   currentTrip != '' ? 'Search for $currentTrip' : 'Your First Trip',
          //   style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
          // ),
          title: Text(
            'Calendar',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(primarySwatch: Colors.grey),
                home: showToday
                    ? const TodayPage()
                    : CalenderPage(current: calendarId),
              );
            }),
      ),
    );
  }
}
