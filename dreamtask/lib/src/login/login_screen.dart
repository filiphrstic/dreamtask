import 'package:dreamtask/src/login/bloc/login_bloc.dart';
import 'package:dreamtask/src/login/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  LoginScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginBloc();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),

          // To work with lists that may contain a large number of items, it’s best
          // to use the ListView.builder constructor.
          //
          // In contrast to the default ListView constructor, which requires
          // building all Widgets up front, the ListView.builder constructor lazily
          // builds Widgets as they’re scrolled into view.
          body: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocProvider(
                    create: (context) => loginBloc,
                    child: BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {},
                      child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        if (state is LoginInitial) {
                          return Text('initial');
                        }
                        if (state is LoginLoading) {
                          // return CircularProgressIndicator();
                          return Text('loading');
                        }
                        if (state is SuccessfulLoginState) {
                          return Text('Login successfull' +
                              state.loginResponse.toString());
                        }
                        if (state is ErrorLoginState) {
                          return Text(state.loginError);
                        } else
                          return Text('Unhandled state');
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: loginUsernameController,
                      decoration: const InputDecoration(hintText: 'username'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: loginPasswordController,
                      decoration: const InputDecoration(hintText: 'password'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        loginBloc.add(UserLoginEvent(
                            loginUsernameController.text,
                            loginPasswordController.text));
                      },
                      child: const Text('Log in')),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, RegistrationScreen.routeName);
                        },
                        child: const Text('Register'))
                  ]),
                ]),
          )),
    );
  }
}
