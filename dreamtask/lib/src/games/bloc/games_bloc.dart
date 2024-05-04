import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final Dio dio = Dio(BaseOptions());

  final secureStorage = const FlutterSecureStorage();
  GamesBloc() : super(GamesInitial()) {
    on<FetchGamesEvent>((event, emit) async {
      try {
        emit(GamesLoading());
        var authToken = await secureStorage.read(key: 'token');
        print(authToken.toString());
        final response = await dio.get(
          'https://tictactoe.aboutdream.io/games/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }),
        );

        if (response.statusCode == 200) {
          emit(SuccessfulGamesState(response.data));
        }
      } catch (e) {
        emit(ErrorGamesState(e.toString()));
        // print(e);
      }
    });
  }
}
