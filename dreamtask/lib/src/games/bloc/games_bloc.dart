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
      // var username = await secureStorage.read(key: 'username');
      String id = await secureStorage.read(key: 'id') ?? "0";

      if (event.gamesEndpoint.isNotEmpty) {
        gamesEndpoint = event.gamesEndpoint;
      } else {
        gamesEndpoint = 'https://tictactoe.aboutdream.io/games/';
      }
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        final response = await dio.get(
          gamesEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
            // 'Authorization': 'Bearer 0bf4e801698d25b9e44e4303c5250c2bde31a072',
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
        // emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        // var firstPlayer = await secureStorage.read(key: 'username');
        // print(firstPlayer.toString());
        await dio.post(
          gamesEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
            // 'Authorization': 'Bearer 0bf4e801698d25b9e44e4303c5250c2bde31a072',
          }),
        );
        // if (response.statusCode == 200) {
        // emit(SuccessfulCreateNewGameState());
        // }
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
        // print(currentGameEndpoint);
        // var firstPlayer = await secureStorage.read(key: 'username');
        // print(firstPlayer.toString());
        final response = await dio.get(
          currentGameEndpoint,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
            // 'Authorization': 'Bearer 0bf4e801698d25b9e44e4303c5250c2bde31a072',
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
      // String currentPlayerId = await secureStorage.read(key: 'id') ?? "0";
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
              // 'Authorization': 'Bearer 0bf4e801698d25b9e44e4303c5250c2bde31a072',
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

    on<JoinGameEvent>((event, emit) async {
      // String currentPlayerId = await secureStorage.read(key: 'id') ?? "0";
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
              // 'Authorization': 'Bearer 0bf4e801698d25b9e44e4303c5250c2bde31a072',
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
