// import 'package:flutter/material.dart';
// import 'pages/Home.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() async {
//   await dotenv.load(); // Load the .env file
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MA Traveling Suggestion',
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const Home(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './repository/user_repository.dart';
import './bloc/authentication_bloc.dart';
import './splash/splash.dart';
import './login/login_page.dart';
import './home/home.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event); // Log events for debugging
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition); // Log state transitions for debugging
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('Error: $error'); // Log errors for debugging
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  final userRepository = UserRepository();

  runApp(App(userRepository: userRepository));
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  const App({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted()), // Trigger the AppStarted event
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            // Handle different authentication states
            if (state is AuthenticationUninitialized) {
              return const SplashPage(); // Show splash screen while initializing
            } else if (state is AuthenticationAuthenticated) {
              return HomePage(); // Show home page if authenticated
            } else if (state is AuthenticationUnauthenticated) {
              return LoginPage(
                  userRepository:
                      userRepository); // Show login page if unauthenticated
            } else if (state is AuthenticationLoading) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading indicator
            }
            return const SizedBox.shrink(); // Default return statement
          },
        ),
      ),
    );
  }
}
