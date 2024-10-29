// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../login/bloc/login_bloc.dart';

// class LoginForm extends StatefulWidget {
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _onLoginButtonPressed() {
//       BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
//         username: _usernameController.text,
//         password: _passwordController.text,
//       ));
//     }

//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginFaliure) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('${state.error}'),
//             backgroundColor: Colors.red,
//           ));
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           return Container(
//             child: Form(
//               child: Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           labelText: 'username', icon: Icon(Icons.person)),
//                       controller: _usernameController,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           labelText: 'password', icon: Icon(Icons.security)),
//                       controller: _passwordController,
//                       obscureText: true,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       height: MediaQuery.of(context).size.width * 0.22,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 30.0),
//                         child: ElevatedButton(
//                           onPressed: state is! LoginLoading
//                               ? _onLoginButtonPressed
//                               : null,
//                           style: ElevatedButton.styleFrom(
//                             shape: const StadiumBorder(
//                               side: BorderSide(
//                                 color: Colors.black,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 24.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: state is LoginLoading
//                           ? const CircularProgressIndicator()
//                           : null,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../login/bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _onLoginButtonPressed() {
      context.read<LoginBloc>().add(LoginButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          // Update to LoginFailure
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        icon: Icon(Icons.person),
                      ),
                      controller: _usernameController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.security),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          onPressed: state is! LoginLoading
                              ? _onLoginButtonPressed
                              : null,
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(
                              side: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state is LoginLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
