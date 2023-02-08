// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'classes.dart';

class AppState {
  AppState() {
    // _entriesStreamController = StreamController.broadcast(onListen: () {
    //   _entriesStreamController.add([
    //     Entry(date: 2023-01-21', activities: [
    //       Activity(type: 'Gym', content: 'foo bar baz'),
    //       Activity(type: 'Running', content: 'foo bar baz'),
    //       Activity(type: 'Cycling', content: 'foo bar baz'),
    //     ])
    //   ]);
    // });
  }

  User? user;

  Future<void> logIn(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      user = credential.user!;
      _listenForEntries();
    } else {
      print('no user!');
    }
  }

  void writeEntryToFirebase(Entry entry) {
    // FirebaseFirestore.instance.collection('Entries').add(<String, String>{
    //   'title': entry.title,
    //   'date': entry.date.toString(),
    //   'text': entry.text,
    // });
  }

  void _listenForEntries() {
    // FirebaseFirestore.instance
    //     .collection('Entries')
    //     .snapshots()
    //     .listen((event) {
    //   final entries = event.docs.map((doc) {
    //     final data = doc.data();
    //     return Entry(
    //       date: data['date'] as String,
    //       text: data['text'] as String,
    //       title: data['title'] as String,
    //     );
    //   }).toList();

    //   _entriesStreamController.add(entries);
    // });
  }
}
