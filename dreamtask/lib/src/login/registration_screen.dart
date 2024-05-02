import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({
    super.key,
  });

  static const routeName = '/registration';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: InputDecoration(hintText: 'username'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'password'),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Register')),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Already have an account?'),
                  TextButton(onPressed: () {}, child: Text('Log in'))
                ]),
              ]),
        ));
  }
}
