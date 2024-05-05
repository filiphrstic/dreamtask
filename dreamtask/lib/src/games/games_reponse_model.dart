import 'package:dreamtask/src/games/game_model.dart';

class GamesResponseModel {
  int count;
  String next;
  String previous;
  // List<Map<String, dynamic>> results;
  List<GameModel> gamesList;

  GamesResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    // required this.results,
    required this.gamesList,
  });

  factory GamesResponseModel.fromJSON(Map<String, dynamic> jsonResponse) =>
      GamesResponseModel(
        count: jsonResponse['count'] ?? 0,
        next: jsonResponse['next'] ?? '',
        previous: jsonResponse['previous'] ?? '',
        gamesList: (jsonResponse['results'] as List)
            .map((e) => GameModel.fromJSON(e))
            .toList(),
        // results: (json.decode(jsonResponse['results']) as List)
        //     .cast<Map<String, dynamic>>(),
        // results:
      );

  // void populateGamesList() {
  //   for (var element in results) {
  //     GameModel.fromJSON(element);
  //   }
  // }
}
