import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dreamtask/src/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio = Dio();
  final secureStorage = const FlutterSecureStorage();
  CurrentUserSingleton currentUser = CurrentUserSingleton.instance;
  final String basicUrl = 'https://tictactoe.aboutdream.io/';

  LoginBloc() : super(LoginInitial()) {
    on<UserLoginEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        final response = await dio.post(
          '${basicUrl}login/',
          data: {'username': event.username, 'password': event.password},
        );
        await secureStorage.write(
          key: 'token',
          value: response.data['token'],
        );
        currentUser.id = response.data['id'];
        currentUser.username = response.data['username'];
        if (response.statusCode == 200) {
          emit(
            SuccessfulLoginState(response.data),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          emit(
            ErrorLoginState(
                'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'),
          );
        }
      }
    });

    on<UserRegistrationEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        Response response = await dio.post(
          '${basicUrl}register/',
          data: {'username': event.username, 'password': event.password},
        );
        if (response.statusCode == 200) {
          emit(
            SuccessfulRegistrationState(),
          );
        }
      } on DioException catch (e) {
        if (e.response != null) {
          emit(
            ErrorLoginState(
                'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'),
          );
        }
      }
    });

    on<UserLogoutEvent>((event, emit) async {
      try {
        var authToken = await secureStorage.read(key: 'token');
        Response response = await dio.post(
          '${basicUrl}logout/',
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
          emit(
            ErrorLoginState(
                'Error ${e.response!.statusCode}: ${e.response!.data['errors'][0]['message']}'),
          );
        }
      }
    });
  }
}
