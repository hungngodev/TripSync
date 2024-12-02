import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './repository/user_repository.dart';
import './bloc/authentication_bloc.dart';
import './splash/splash.dart';
import './bloc/authentication_state.dart';
import './login/welcom_page.dart';
import 'pages/home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

void main() async {
  await dotenv.load(); // Load the .env file
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            print("State: $state");
            // Handle different authentication states
            if (state is AuthenticationUninitialized) {
              return const SplashPage(); // Show splash screen while initializing
            } else if (state is AuthenticationAuthenticated) {
              print('Authenticated');
              return HomePage(); // Show home page if authenticated
            } else if (state is AuthenticationUnauthenticated) {
              print('Unauthenticated');
              return WelcomePage(
                  userRepository:
                      userRepository); // Show login page if unauthenticated
            } else if (state is AuthenticationLoading) {
              print('Loading');
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
