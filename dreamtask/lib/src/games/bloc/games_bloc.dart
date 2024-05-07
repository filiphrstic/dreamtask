import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dreamtask/src/games/game_model.dart';
import 'package:dreamtask/src/games/games_reponse_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final Dio dio = Dio(BaseOptions());

  final secureStorage = const FlutterSecureStorage();
  String gamesEndpoint = 'https://tictactoe.aboutdream.io/games/';
  GamesBloc() : super(GamesInitial()) {
    on<FetchGamesEvent>((event, emit) async {
      String id = await secureStorage.read(key: 'id') ?? "0";

      if (event.gamesEndpoint.isNotEmpty) {
        gamesEndpoint = event.gamesEndpoint;
      } else {
        gamesEndpoint = 'https://tictactoe.aboutdream.io/games/';
      }
      try {
        var authToken = await secureStorage.read(key: 'token');
        final response = await dio.get(
          gamesEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );

        if (response.statusCode == 200) {
          GamesResponseModel gamesResponseModel =
              GamesResponseModel.fromJSON(response.data);
          emit(SuccessfulGamesState(gamesResponseModel, int.parse(id)));
        }
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
      }
    });

    on<CreateNewGameEvent>((event, emit) async {
      try {
        var authToken = await secureStorage.read(key: 'token');
        await dio.post(
          gamesEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
      }
    });

    on<FetchCurrentGameDetails>((event, emit) async {
      String currentPlayerId = await secureStorage.read(key: 'id') ?? "0";
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        final currentGameEndpoint = '$gamesEndpoint${event.gameId}/';
        final response = await dio.get(
          currentGameEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );
        if (response.statusCode == 200) {
          GameModel currentGameModel = GameModel.fromJSON(response.data);
          emit(SuccessfulCurrentGameDetails(
              currentGameModel, int.parse(currentPlayerId)));
        }
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
      }
    });

    on<MakeMoveEvent>((event, emit) async {
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        final currentGameEndpoint = '$gamesEndpoint${event.gameId}/move/';
        final response = await dio.post(
          currentGameEndpoint,
          data: event.params,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          add(FetchCurrentGameDetails(event.gameId));
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorGamesState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });

    on<JoinGameEvent>((event, emit) async {
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        final currentGameEndpoint = '$gamesEndpoint${event.gameId}/join/';
        final response = await dio.post(
          currentGameEndpoint,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          add(FetchCurrentGameDetails(event.gameId));
        }
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
      }
    });
  }
}
