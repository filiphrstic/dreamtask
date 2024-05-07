part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class UserLoginEvent extends LoginEvent {
  final String username;
  final String password;

  UserLoginEvent(this.username, this.password);
}

class UserRegistrationEvent extends LoginEvent {
  final String username;
  final String password;

  UserRegistrationEvent(this.username, this.password);
}

class UserLogoutEvent extends LoginEvent {}
