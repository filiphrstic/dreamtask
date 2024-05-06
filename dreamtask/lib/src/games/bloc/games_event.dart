part of 'games_bloc.dart';

@immutable
sealed class GamesEvent {}

class FetchGamesEvent extends GamesEvent {
  final String gamesEndpoint;

  FetchGamesEvent(this.gamesEndpoint);
}

class CreateNewGameEvent extends GamesEvent {}

class FetchCurrentGameDetails extends GamesEvent {
  final int gameId;

  FetchCurrentGameDetails(this.gameId);
}
