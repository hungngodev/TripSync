import 'package:flutter/material.dart';
import 'package:flutter_application/nagivation.dart';
import 'package:flutter_application/pages/Calendars.dart';
import 'package:flutter_application/pages/createcalendar.dart';
import 'package:flutter_application/ui_components/input_form.dart';
import 'package:flutter_application/ui_components/button.dart';
import '../services/openai/gpt_service.dart';
import '../util/keyword.dart';
import './/util/location.dart';
import 'package:flutter_application/pages/Home.dart';

class Signup extends StatelessWidget {
  Signup({super.key});


  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  signIn(){}

  openHomePage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const NavigationMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 400,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CustomInputForm(icon: Icons.person, label: "Username", hint: "username", controller: usernameController,),
    
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CustomInputForm(icon: Icons.lock_sharp, label: "Password", hint: "password", controller: passwordController, obscureText: true,),
    
              ),
              const SizedBox(height: 15,),
              Button(
                onTap: () => openHomePage(context),
              ),            

              
            ],
          ),
        ),
      ),
    );
    
  }
}
