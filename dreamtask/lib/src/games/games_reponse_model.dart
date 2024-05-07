import 'package:dreamtask/src/games/game_model.dart';

class GamesResponseModel {
  int count;
  String next;
  String previous;
  List<GameModel> gamesList;

  GamesResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.gamesList,
  });

  factory GamesResponseModel.fromJSON(Map<String, dynamic> jsonResponse) =>
      GamesResponseModel(
        count: jsonResponse['count'] ?? 0,
        next: jsonResponse['next'] ?? '',
        previous: jsonResponse['previous'] ?? '',
        gamesList: (jsonResponse['results'] as List)
            .map(
              (e) => GameModel.fromJSON(e),
            )
            .toList(),
      );
}
