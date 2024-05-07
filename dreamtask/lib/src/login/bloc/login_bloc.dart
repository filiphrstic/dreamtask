import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio = Dio();
  final secureStorage = const FlutterSecureStorage();

  LoginBloc() : super(LoginInitial()) {
    on<UserLoginEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        final response = await dio.post(
          'https://tictactoe.aboutdream.io/login/',
          data: {'username': event.username, 'password': event.password},
        );
        await secureStorage.write(
          key: 'token',
          value: response.data['token'],
        );
        await secureStorage.write(
          key: 'username',
          value: response.data['username'],
        );
        await secureStorage.write(
          key: 'id',
          value: response.data['id'].toString(),
        );
        // print(response.data['token']);

        // var responseMap = json.decode(response.data);
        // print(responseMap);

        if (response.statusCode == 200) {
          emit(SuccessfulLoginState(response.data));
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorLoginState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });

    on<UserRegistrationEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        Response response = await dio.post(
          'https://tictactoe.aboutdream.io/register/',
          data: {'username': event.username, 'password': event.password},
        );
        if (response.statusCode == 200) {
          emit(
            SuccessfulRegistrationState(),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorLoginState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });

    on<UserLogoutEvent>((event, emit) async {
      try {
        var authToken = await secureStorage.read(key: 'token');
        Response response = await dio.post(
          'https://tictactoe.aboutdream.io/logout/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          secureStorage.deleteAll();
          emit(
            SuccessfulLogoutState(),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data['errors'][0]['message']);
          emit(ErrorLoginState(
              'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'));
        }
        // print(e);
      }
    });
  }
}

// String _handleError(DioException error) {
//   if (error.type == DioExceptionType.badResponse) {
//     return error.message ?? '';
//   } else {
//     return "Error";
//   }
// }

// class ErrorHandler implements Exception {
//   ErrorHandler.handle(dynamic error) {
//     if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
//       _handleError(error);
//     }
//   }
// }
