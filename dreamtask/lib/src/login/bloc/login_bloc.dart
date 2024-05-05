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
        await secureStorage.write(key: 'token', value: response.data['token']);
        // print(response.data['token']);

        // var responseMap = json.decode(response.data);
        // print(responseMap);

        if (response.statusCode == 200) {
          emit(SuccessfulLoginState(response.data));
        }
      } catch (e) {
        emit(ErrorLoginState(e.toString()));
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
      } catch (e) {
        emit(
          ErrorLoginState(
            e.toString(),
          ),
        );
        // print(e);
      }
    });
  }
}
