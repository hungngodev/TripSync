import 'package:flutter/material.dart';
import './search_page.dart';
import './profile_page.dart';
import './posts.dart';
import './setting_page.dart';
import './calendar_page.dart';
import './friends.dart';
import './creation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
          Icon(Icons.account_circle,
              size: 30, color: _page == 3 ? Colors.white : Colors.black),
          Icon(Icons.settings,
              size: 30, color: _page == 4 ? Colors.white : Colors.black),
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
        const CreationScreen(),
        const SearchPage(),
        const CalendarPage(),

        /// Messages page
        PostPage(),
        const SettingPage()
      ][_page],
    );
  }
}
