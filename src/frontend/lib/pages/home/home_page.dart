import 'package:flutter/material.dart';
import './search_page.dart';
import './profile_page.dart';
import './setting_page.dart';
import './calendar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 147, 139, 174),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.home_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.calendar_today)),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.account_circle),
            ),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.settings),
            ),
            label: 'Setting',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        SearchPage(),

        /// Notifications page
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 1'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 2'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        CalendarPage(),

        /// Messages page
        ProfilePage(),
        SettingPage()
      ][currentPageIndex],
    );
  }
}
