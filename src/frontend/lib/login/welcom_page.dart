import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';
import '../bloc/authentication_bloc.dart';
import '../login/bloc/login_bloc.dart';
import './login.dart';
import './signup.dart';

class WelcomePage extends StatefulWidget {
  final UserRepository userRepository;

  const WelcomePage({required this.userRepository, super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Keep track of the current view: welcome, login, or signup
  String currentView = "welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentView == "welcome"
            ? _buildWelcomeView()
            : currentView == "login"
                ? _buildLoginView()
                : _buildSignupView(),
      ),
    );
  }

  // Welcome view
  Widget _buildWelcomeView() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: const Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
              const SizedBox(height: 20),
              FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Text(
                    "Automatic identity verification which enables you to verify your identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  )),
            ],
          ),
          FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://github.com/afgprogrammer/Flutter-Login-Signup-page/blob/master/assets/Illustration.png?raw=trueg'),
                  ),
                ),
              )),
          Column(
            children: <Widget>[
              FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      setState(() {
                        currentView = "login"; // Switch to login view
                      });
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  )),
              const SizedBox(height: 20),
              FadeInUp(
                  duration: const Duration(milliseconds: 1600),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        setState(() {
                          currentView = "signup"; // Switch to signup view
                        });
                      },
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  // Login view
  Widget _buildLoginView() {
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        userRepository: widget.userRepository,
      ),
      child: LoginPage(
        onBack: () {
          setState(() {
            currentView = "welcome"; // Go back to welcome view
          });
        },
      ),
    );
  }

  // Signup view
  Widget _buildSignupView() {
    return SignUpPage(onBack: () {
      setState(() {
        currentView = "welcome"; // Go back to welcome view
      });
    }, navigateToLogin: () {
      setState(() {
        currentView = "login"; // Switch to login view
      });
    });
  }
}
