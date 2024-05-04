part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

class SuccessfulLoginState extends LoginState {
  final dynamic loginResponse;

  SuccessfulLoginState(this.loginResponse);
}

class SuccessfulRegistrationState extends LoginState {
  SuccessfulRegistrationState();
}

class ErrorLoginState extends LoginState {
  final String loginError;

  ErrorLoginState(this.loginError);
}
