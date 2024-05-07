part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class FetchUserDetailsLoading extends UsersState {}

final class FetchFirstPlayerSuccessfully extends UsersState {
  final UserModel user;
  FetchFirstPlayerSuccessfully(this.user);
}

final class FetchSecondPlayerSuccessfully extends UsersState {
  final UserModel user2;
  FetchSecondPlayerSuccessfully(this.user2);
}

final class ErrorUserState extends UsersState {
  final String userError;
  ErrorUserState(this.userError);
}
