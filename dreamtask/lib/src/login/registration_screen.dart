import 'package:dreamtask/src/login/bloc/login_bloc.dart';
import 'package:dreamtask/src/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';
  const RegistrationScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  final registrationUsernameController = TextEditingController();
  final registrationPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginBloc();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registration'),
        ),
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
                        return Container();
                      }
                      if (state is LoginLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is SuccessfulRegistrationState) {
                        return Column(
                          children: [
                            const Text('Registration successfull'),
                            TextButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, LoginScreen.routeName);
                              },
                              child: const Text('Please log in'),
                            )
                          ],
                        );
                      }
                      if (state is ErrorLoginState) {
                        return Text(
                          state.loginError,
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        return const Text('Unhandled state');
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: registrationUsernameController,
                    decoration: const InputDecoration(hintText: 'username'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: registrationPasswordController,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      loginBloc.add(
                        UserRegistrationEvent(
                            registrationUsernameController.text,
                            registrationPasswordController.text),
                      );
                    },
                    child: const Text('Register')),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, LoginScreen.routeName);
                    },
                    child: const Text('Log in'),
                  )
                ]),
              ]),
        ),
      ),
    );
  }
}
