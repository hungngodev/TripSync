// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import '/repository/user_repository.dart';
// import '/model/user_model.dart';

// part 'authentication_event.dart';
// part 'authentication_state.dart';

// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//   AuthenticationBloc({required this.userRepository})
//       : assert(userRepository != null),
//         super(AuthenticationUninitialized());

//   final UserRepository userRepository;

//   @override
//   Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
//     if (event is AppStarted) {
//       final bool hasToken = await userRepository.hasToken();

//       if (hasToken) {
//         yield AuthenticationAuthenticated();
//       } else {
//         yield AuthenticationUnauthenticated();
//       }
//     }

//     if (event is LoggedIn) {
//       yield AuthenticationLoading();

//       try {
//         await userRepository.persistToken(user: event.user);
//         yield AuthenticationAuthenticated();
//       } catch (e) {
//         // Handle any errors if necessary
//         yield AuthenticationUnauthenticated();
//       }
//     }

//     if (event is LoggedOut) {
//       yield AuthenticationLoading();

//       try {
//         await userRepository.deleteToken(id: 0); // Ensure you pass the correct ID
//         yield AuthenticationUnauthenticated();
//       } catch (e) {
//         // Handle any errors if necessary
//         yield AuthenticationUnauthenticated();
//       }
//     }
//   }
// }
// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import '/repository/user_repository.dart';
// import '/model/user_model.dart';

// part 'authentication_event.dart';
// part 'authentication_state.dart';

// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationState> {
//   final UserRepository userRepository;

//   AuthenticationBloc({required this.userRepository})
//       : super(AuthenticationUninitialized()) {
//     on<AppStarted>(_onAppStarted);
//     on<LoggedIn>(_onLoggedIn);
//     on<LoggedOut>(_onLoggedOut);
//   }

//   Future<void> _onAppStarted(
//       AppStarted event, Emitter<AuthenticationState> emit) async {
//     final bool hasToken = await userRepository.hasToken();

//     if (hasToken) {
//       emit(AuthenticationAuthenticated());
//     } else {
//       emit(AuthenticationUnauthenticated());
//     }
//   }

//   Future<void> _onLoggedIn(
//       LoggedIn event, Emitter<AuthenticationState> emit) async {
//     emit(AuthenticationLoading());
//     await userRepository.persistToken(user: event.user);
//     emit(AuthenticationAuthenticated());
//   }

//   Future<void> _onLoggedOut(
//       LoggedOut event, Emitter<AuthenticationState> emit) async {
//     emit(AuthenticationLoading());
//     await userRepository.deleteToken(id: 0);
//     emit(AuthenticationUnauthenticated());
//   }
// }
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/repository/user_repository.dart';
import '/model/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    try {
      final hasToken = await userRepository.hasToken();
      if (hasToken) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (_) {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await userRepository.persistToken(user: event.user);
    emit(AuthenticationAuthenticated());
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await userRepository.deleteToken(id: 0);
    emit(AuthenticationUnauthenticated());
  }
}
