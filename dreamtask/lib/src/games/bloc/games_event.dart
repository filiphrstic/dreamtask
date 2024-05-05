part of 'games_bloc.dart';

@immutable
sealed class GamesEvent {}

class FetchGamesEvent extends GamesEvent {
  final String fetchGamesUrl;

  FetchGamesEvent(this.fetchGamesUrl);
}
