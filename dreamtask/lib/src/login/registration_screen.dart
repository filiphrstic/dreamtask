import 'package:dreamtask/src/login/login_screen.dart';
import 'package:flutter/material.dart';

/// Displays a list of SampleItems.
class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({
    super.key,
  });

  static const routeName = '/registration';

  final registrationUsernameController = TextEditingController();
  final registrationPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Registration'),
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
                      onPressed: () {}, child: const Text('Register')),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Already have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, LoginScreen.routeName);
                        },
                        child: const Text('Log in'))
                  ]),
                ]),
          )),
    );
  }
}
