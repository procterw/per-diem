import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  Activity({required this.type, required this.note});
  final String type;
  final String note;

  factory Activity.fromJson(Map<String, dynamic> data) {
    final type = data['type'] as String;
    final note = data['note'] as String;
    return Activity(type: type, note: note);
  }
}

class ActivityDef {
  ActivityDef({required this.type, required this.icon, required this.color});
  final String type;
  final String icon;
  final String color;

  factory ActivityDef.fromJson(Map<dynamic, dynamic> data) {
    final type = data['type'] as String;
    final icon = data['icon'] as String;
    final color = data['color'] as String;
    return ActivityDef(type: type, icon: icon, color: color);
  }
}

class Entry {
  Entry(
      {required this.date, required this.dateString, required this.activities});
  final int date;
  final String dateString;
  final List<Activity> activities;

  factory Entry.fromJson(Map<String, dynamic> data) {
    final date = data['date'] as int;
    final d = date.toString();
    final dateString =
        '${d.substring(0, 4)}-${d.substring(4, 6)}-${d.substring(6, 8)}';
    final activities = data['activities'].map<Activity>((d) {
      return Activity.fromJson(d);
    }).toList();
    final x = Entry(date: date, dateString: dateString, activities: activities);
    return Entry(date: date, dateString: dateString, activities: activities);
  }
}

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void clear() async {
    await _firestore.terminate();
    await _firestore.clearPersistence();
  }

  Stream get allEntries => _firestore
      .collection('entries')
      .withConverter<Entry>(
        fromFirestore: (snapshots, _) {
          print('bad:');
          print(snapshots.data());
          return Entry.fromJson(snapshots.data()!);
        },
        toFirestore: (entry, _) => {'foo': 'bar'},
      )
      .snapshots();

  // Future<bool> editEntry(Entry e) {
  //   entries = _firestore.collection('entries');
  //   try {
  //     await _movies.doc()
  //   }
  // };
}
