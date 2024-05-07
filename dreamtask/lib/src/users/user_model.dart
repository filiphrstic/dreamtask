// ignore_for_file: non_constant_identifier_names

class UserModel {
  int id;
  String username;
  int game_count;
  double win_rate;

  UserModel({
    required this.id,
    required this.username,
    required this.game_count,
    required this.win_rate,
  });

  factory UserModel.fromJSON(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? 0,
        username: json['username'] ?? 0,
        game_count: json['game_count'] ?? 0,
        win_rate: json['win_rate'] ?? 0.0,
      );
}

class CurrentUserSingleton {
  late int id;
  late String username;

  CurrentUserSingleton._private();

  static CurrentUserSingleton _instance = CurrentUserSingleton._private();
  static CurrentUserSingleton get instance => _instance;
}
