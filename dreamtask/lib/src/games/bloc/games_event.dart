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
  // final int firstPlayer;
  // final int secondPlayer;

  FetchCurrentGameDetails(
    this.gameId,
    // this.firstPlayer,
    // this.secondPlayer,
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

class FetchFirstPlayer extends GamesEvent {
  final int id;

  FetchFirstPlayer(this.id);
}

class FetchSecondPlayer extends GamesEvent {
  final int id;

  FetchSecondPlayer(this.id);
}
