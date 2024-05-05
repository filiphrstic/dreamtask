part of 'games_bloc.dart';

@immutable
sealed class GamesState {}

final class GamesInitial extends GamesState {}

final class GamesLoading extends GamesState {}

final class SuccessfulGamesState extends GamesState {
  final GameModel gamesResponse;

  SuccessfulGamesState(this.gamesResponse);
}

final class ErrorGamesState extends GamesState {
  final String gamesError;
  ErrorGamesState(this.gamesError);
}
