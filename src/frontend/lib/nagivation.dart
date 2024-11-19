import 'package:flutter/material.dart';
// import 'pages/Home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home.dart';
import 'pages/Calendars.dart';
import 'pages/createcalendar.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int myIndex = 0;
  List<Widget> widgetlist = const [
    Home(),
    Calendars(),
    Createcalendar()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: widgetlist,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: myIndex,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (index) =>{
          setState(() {
            myIndex = index;
          })
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home" ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Your Calendars"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),

        ],
        // height: 65,
        // elevation: 0,
      ),

    );
  }
}