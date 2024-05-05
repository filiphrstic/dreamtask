import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dreamtask/src/games/games_reponse_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final Dio dio = Dio(BaseOptions());

  final secureStorage = const FlutterSecureStorage();
  String fetchGamesUrl = 'https://tictactoe.aboutdream.io/games/';
  GamesBloc() : super(GamesInitial()) {
    on<FetchGamesEvent>((event, emit) async {
      if (event.fetchGamesUrl.isNotEmpty) {
        fetchGamesUrl = event.fetchGamesUrl;
      } else {
        fetchGamesUrl = 'https://tictactoe.aboutdream.io/games/';
      }
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        final response = await dio.get(
          fetchGamesUrl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );

        if (response.statusCode == 200) {
          GamesResponseModel gamesResponseModel =
              GamesResponseModel.fromJSON(response.data);
          emit(SuccessfulGamesState(gamesResponseModel));
        }
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
      }
    });
  }
}
