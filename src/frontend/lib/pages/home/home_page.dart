import 'package:flutter/material.dart';
import './search_page.dart';
import './profile_page.dart';
import './setting_page.dart';
import './calendar_page.dart';
import '../../login/onboarding_page.dart';

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
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_rounded),
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
        ///

        const SearchPage(),
        const OnboardingPage(),
        const CalendarPage(),

        /// Messages page
        const ProfilePage(),
        const SettingPage()
      ][currentPageIndex],
    );
  }
}
