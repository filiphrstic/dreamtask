import 'package:dreamtask/src/login/registration_screen.dart';
import 'package:flutter/material.dart';

/// Displays a list of SampleItems.
class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  static const routeName = '/login';

  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        print(loginUsernameController.text +
                            " " +
                            loginPasswordController.text);
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
