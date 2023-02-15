// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'app_state.dart';
import './date_list_screen/date_list_screen.dart';
import './calendar_screen/calendar_screen.dart';

class LoggedOutView extends StatelessWidget {
  final AppState state;
  const LoggedOutView({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Emulator Suite Codelab'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please log in',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await state.logIn('test@test.com', 'testtest').then((_) {
                    if (state.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          // return const DateListScreen();
                          return CalendarScreen();
                        }),
                      );
                    }
                  });
                },
                child: const Text('Log In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
