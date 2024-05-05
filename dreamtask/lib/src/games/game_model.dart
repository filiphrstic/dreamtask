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

  factory GameModel.fromJSON(Map<String, dynamic> json) => new GameModel(
      id: json['id'] == null ? 0 : json['id'],
      board: json['board'] == null ? [0] : json['board'],
      winner: json['winner'] == null ? {'winner': 0} : json['winner'],
      firstPlayer: json['first_player'] == {'first_player': 0}
          ? null
          : json['first_player'],
      secondPlayer: json['second_player'] == null
          ? {'second_player': 0}
          : json['second_player'],
      created: json['created'] == null ? 'null' : json['created'],
      status: json['status'] == null ? 'null' : json['status']);
}
