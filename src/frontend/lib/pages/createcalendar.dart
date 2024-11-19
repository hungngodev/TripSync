import 'package:flutter/material.dart';
import 'package:flutter_application/pages/Home.dart';
import 'package:flutter_application/ui_components/input_form.dart';

class Createcalendar extends StatefulWidget {
  const Createcalendar({super.key});

  @override
  State<Createcalendar> createState() => _CreatecalendarState();
}

class _CreatecalendarState extends State<Createcalendar> {
  TextEditingController calendarNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Calendar"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomInputForm(icon: Icons.event_outlined, label: "Calendar name", hint: "", controller: calendarNameController,),
            const SizedBox(
              height: 8,
            ),
            CustomInputForm(icon: Icons.location_on_outlined, label: "Location", hint: "", controller: locationController,),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 223, 194),
              ),
              onPressed: () => {
                if (calendarNameController.text == "" || locationController.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location and name fields are required")))
                }
              }, child: const Text("Confirm", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),)),
          ],
            
        ),
      ),
    );
  }
}
