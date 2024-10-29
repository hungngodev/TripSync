// part of 'authentication_bloc.dart';

// abstract class AuthenticationEvent extends Equatable {
//   const AuthenticationEvent();

//   @override
//   List<Object> get props => [];
// }

// class AppStarted extends AuthenticationEvent {}

// class LoggedIn extends AuthenticationEvent {
//   final User user;

//   const LoggedIn({required this.user});

//   @override
//   List<Object> get props => [user];

//   @override
//   String toString() => 'LoggedIn { user: ${user.username} }'; // Corrected line
// }

// class LoggedOut extends AuthenticationEvent {}
part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;

  const LoggedIn({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'LoggedIn { user: ${user.username} }'; // Corrected syntax
}

class LoggedOut extends AuthenticationEvent {}
