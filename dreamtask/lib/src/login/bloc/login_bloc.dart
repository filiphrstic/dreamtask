import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio = Dio();

  // LoginState get loginInitial => LoginInitial();

  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   if (event is UserLoginEvent) {
  //     yield LoginInitial();

  //     try {
  //       Response response = await dio.post(
  //           'https://tictactoe.aboutdream.io/login/',
  //           data: {'username': event.username, 'password': event.password});
  //       if (response.statusCode == 200) {
  //         yield SuccessfulLoginState(response.data);
  //       } else {
  //         yield ErrorLoginState('Error, status code: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       yield ErrorLoginState('Error: $e');
  //     }
  //   }
  // }

  LoginBloc() : super(LoginInitial()) {
    on<UserLoginEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        Response response = await dio.post(
            'https://tictactoe.aboutdream.io/login/',
            data: {'username': event.username, 'password': event.password});
        if (response.statusCode == 200) {
          emit(SuccessfulLoginState(response.data));
        } else {
          emit(ErrorLoginState('Error, status code: ${response.statusCode}'));
        }
      } catch (e) {
        emit(ErrorLoginState(e.toString()));
        print(e);
      }
    });
  }
}