import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import './creation.dart';
import './friends.dart';
import './posts.dart';
import './search_page.dart';
import './setting_page.dart';
import 'outer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  String calendarToNavigate = '';

  void navigateToCalendar(calendarId, page) {
    _bottomNavigationKey.currentState?.setPage(page);
    calendarToNavigate = calendarId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: const Color.fromARGB(255, 147, 139, 174),
        color: const Color.fromARGB(255, 186, 187, 190),
        backgroundColor: Colors.white,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home_outlined,
              size: 30, color: _page == 0 ? Colors.white : Colors.black),
          Icon(Icons.search_rounded,
              size: 30, color: _page == 1 ? Colors.white : Colors.black),
          Icon(Icons.calendar_today,
              size: 30, color: _page == 2 ? Colors.white : Colors.black),
          Icon(Icons.feed,
              size: 30, color: _page == 3 ? Colors.white : Colors.black),
          Icon(Icons.people,
              size: 30, color: _page == 4 ? Colors.white : Colors.black),
          Icon(Icons.settings,
              size: 30, color: _page == 5 ? Colors.white : Colors.black),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: <Widget>[
        /// Home page
        ///
        CreationScreen(
          calendarNav: navigateToCalendar,
        ),
        SearchPage(calendarId: calendarToNavigate),
        calendarToNavigate == ''
            ? OuterPage()
            : OuterPage(showToday: false, calendarId: calendarToNavigate),

        /// Messages page
        const PostPage(),
        FriendsPage(),
        const SettingPage()
      ][_page],
    );
  }
}
