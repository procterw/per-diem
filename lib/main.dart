import 'package:dailylog/mock_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'day_list_screen.dart';
import 'app_state.dart';
import 'logged_out_view.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'diem-5a68c',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // try {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // } catch (e) {
  //   // ignore: avoid_print
  //   print(e);
  // }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final state = AppState();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final database = context.read(databaseProvider);
    return MaterialApp(home: LoggedOutView(state: state));

    // if (state.user == null) {
    //   return MaterialApp(home: LoggedOutView(state: state));
    // } else {
    //   return MaterialApp(
    //     title: 'DayTracker',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const DayListScreen(),
    //   );
    // }
  }
}
