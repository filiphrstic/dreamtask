class GameModel {
  int id;
  List<dynamic> board;
  Map<String, dynamic> winner;
  Map<String, dynamic> firstPlayer;
  Map<String, dynamic> secondPlayer;
  String created;
  String status;

  GameModel(
      {required this.id,
      required this.board,
      required this.winner,
      required this.firstPlayer,
      required this.secondPlayer,
      required this.created,
      required this.status});

  factory GameModel.fromJSON(Map<String, dynamic> json) => GameModel(
      id: json['id'] ?? 0,
      board: json['board'] ?? [0],
      winner: json['winner'] ?? {'winner': 0},
      firstPlayer: json['first_player'] ?? {'first_player': 0},
      secondPlayer: json['second_player'] ?? {'second_player': 0},
      created: json['created'] ?? 'null',
      status: json['status'] ?? 'null');
}
