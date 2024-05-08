import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dreamtask/src/rank_list/rank_list_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'rank_list_event.dart';
part 'rank_list_state.dart';

class RankListBloc extends Bloc<RankListEvent, RankListState> {
  final Dio dio = Dio(BaseOptions());
  String usersEndpoint = 'https://tictactoe.aboutdream.io/users/';
  final secureStorage = const FlutterSecureStorage();

  RankListBloc() : super(RankListInitial()) {
    on<FetchRankListEvent>((event, emit) async {
      if (event.rankListEndpoint.isNotEmpty) {
        usersEndpoint = event.rankListEndpoint;
      } else {
        usersEndpoint = 'https://tictactoe.aboutdream.io/users/';
      }
      try {
        var authToken = await secureStorage.read(key: 'token');
        final response = await dio.get(
          usersEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );

        if (response.statusCode == 200) {
          RankListResponseModel rankListResponseModel =
              RankListResponseModel.fromJSON(response.data);
          emit(SuccessfulRankListState(rankListResponseModel));
        }
      } catch (e) {
        emit(ErrorRankListState(e.toString()));
      }
    });
  }
}
