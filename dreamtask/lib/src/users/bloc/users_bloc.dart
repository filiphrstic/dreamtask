import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dreamtask/src/users/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Dio dio = Dio();
  final secureStorage = const FlutterSecureStorage();
  String usersEndpoint = 'https://tictactoe.aboutdream.io/users/';

  UsersBloc() : super(UsersInitial()) {
    on<FetchUserDetails>((event, emit) async {
      try {
        var authToken = await secureStorage.read(key: 'token');
        Response response = await dio.get(
          '$usersEndpoint${event.playerId}/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          UserModel user = UserModel.fromJSON(response.data);
          emit(
            FetchUserDetailsSuccessful(user),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorUserState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });

    on<FetchUserDetails2>((event, emit) async {
      try {
        var authToken = await secureStorage.read(key: 'token');
        Response response = await dio.get(
          '$usersEndpoint${event.playerId2}/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          UserModel user = UserModel.fromJSON(response.data);
          emit(
            FetchUser2DetailsSuccessful(user),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorUserState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });
  }
}
