// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  User? user;

  Future<void> logIn(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      user = credential.user!;
    } else {
      print('no user!');
    }
  }
}
