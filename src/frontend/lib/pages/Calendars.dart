import 'package:flutter/material.dart';
import 'package:flutter_application/pages/Home.dart';
import 'package:flutter_application/pages/createcalendar.dart';

class Calendars extends StatelessWidget {
  const Calendars({super.key});

  // ignore: non_constant_identifier_names
  OpenHomePage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
  }

  openCreateCalendarPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Createcalendar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Calendars"),),
      body: Column(
        children: [
          FloatingActionButton(onPressed: (){
            openCreateCalendarPage(context);
          }, backgroundColor: Colors.blue, child: const Icon(Icons.add, color: Colors.white,)),
          ElevatedButton(onPressed: () => OpenHomePage(context), child: const Text('HomePage')),]
      ),
    );
  }
}