part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class FetchUserDetailsLoading extends UsersState {}

final class FetchUserDetailsSuccessful extends UsersState {
  final UserModel user;

  FetchUserDetailsSuccessful(this.user);
}

final class FetchUser2DetailsSuccessful extends UsersState {
  final UserModel user2;

  FetchUser2DetailsSuccessful(this.user2);
}

final class ErrorUserState extends UsersState {
  final String userError;
  ErrorUserState(this.userError);
}
