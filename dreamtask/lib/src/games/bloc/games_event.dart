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

  FetchCurrentGameDetails(
    this.gameId,
  );
}

class JoinGameEvent extends GamesEvent {
  final int gameId;

  JoinGameEvent(this.gameId);
}

class MakeMoveEvent extends GamesEvent {
  final int gameId;
  final Map<String, dynamic> params;

  MakeMoveEvent(this.gameId, this.params);
}
