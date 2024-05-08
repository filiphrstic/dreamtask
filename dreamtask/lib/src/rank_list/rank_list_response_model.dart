import 'package:dreamtask/src/users/user_model.dart';

class RankListResponseModel {
  int count;
  String next;
  String previous;
  List<UserModel> allUsersList;

  RankListResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.allUsersList,
  });

  factory RankListResponseModel.fromJSON(Map<String, dynamic> jsonResponse) =>
      RankListResponseModel(
        count: jsonResponse['count'] ?? 0,
        next: jsonResponse['next'] ?? '',
        previous: jsonResponse['previous'] ?? '',
        allUsersList: (jsonResponse['results'] as List)
            .map(
              (e) => UserModel.fromJSON(e),
            )
            .toList(),
      );
}
