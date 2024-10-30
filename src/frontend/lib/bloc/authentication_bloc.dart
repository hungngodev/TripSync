import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/repository/user_repository.dart';
import '/model/user_model.dart';
import 'authentication_state.dart';

part 'authentication_event.dart';
// part 'authentication_state.dart';

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
        print('Has token');
        emit(AuthenticationAuthenticated());
      } else {
        print('No token');
        emit(AuthenticationUnauthenticated());
      }
    } catch (_) {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    print('Logged in');
    emit(AuthenticationLoading());
    try {
      await userRepository.persistToken(user: event.user);
      emit(AuthenticationAuthenticated());
      print('Emitted authenticated');
    } catch (e) {
      print('Error: $e');
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    print('Logged out');
    emit(AuthenticationLoading());
    await userRepository.deleteToken(id: 0);
    emit(AuthenticationUnauthenticated());
    print('Emitted unauthenticated');
  }
}
