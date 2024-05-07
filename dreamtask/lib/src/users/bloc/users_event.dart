part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class FetchUserDetails extends UsersEvent {
  final int playerId;

  FetchUserDetails(this.playerId);
}

class FetchUserDetails2 extends UsersEvent {
  final int playerId2;

  FetchUserDetails2(this.playerId2);
}
