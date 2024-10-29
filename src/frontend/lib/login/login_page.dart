import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';
import '../bloc/authentication_bloc.dart';
import '../login/bloc/login_bloc.dart';
import '../login/login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  const LoginPage({required this.userRepository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login | Home Hub'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(userRepository: userRepository),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authenticationBloc: context.read<AuthenticationBloc>(),
              userRepository: userRepository,
            ),
          ),
        ],
        child: LoginForm(),
      ),
    );
  }
}
