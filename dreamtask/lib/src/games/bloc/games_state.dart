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

final class ErrorGamesState extends GamesState {
  final String gamesError;
  ErrorGamesState(this.gamesError);
}

final class SuccessfulCurrentGameDetails extends GamesState {
  final GameModel currentGameResponse;
  final int currentPlayerId;

  SuccessfulCurrentGameDetails(this.currentGameResponse, this.currentPlayerId);
}

final class SuccessfulMakeMove extends GamesState {}

final class SuccessfulFirstPlayer extends GamesState {
  final UserModel firstPlayer;

  SuccessfulFirstPlayer(this.firstPlayer);
}

final class SuccessfulSecondPlayer extends GamesState {
  final UserModel secondPlayer;

  SuccessfulSecondPlayer(this.secondPlayer);
}
