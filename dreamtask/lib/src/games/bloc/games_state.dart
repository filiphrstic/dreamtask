part of 'games_bloc.dart';

@immutable
sealed class GamesState {}

final class GamesInitial extends GamesState {}

final class GamesLoading extends GamesState {}

final class SuccessfulGamesState extends GamesState {
  final GamesResponseModel gamesResponse;
  final int id;

  SuccessfulGamesState(this.gamesResponse, this.id);
}

// final class SuccessfulCreateNewGameState extends GamesState {}
final class ErrorGamesState extends GamesState {
  final String gamesError;
  ErrorGamesState(this.gamesError);
}

// final class CurrentGameInitial extends GamesState {}

final class SuccessfulCurrentGameDetails extends GamesState {
  final GameModel currentGameResponse;

  SuccessfulCurrentGameDetails(this.currentGameResponse);
}
