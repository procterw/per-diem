import 'dart:ffi';
import 'dart:async';

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

  toJson() {
    return {
      'type': type,
      'note': note,
    };
  }

  Activity updateNote(note) {
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

class ActivityOption {
  ActivityOption({required this.type, required this.icon});
  final String type;
  final String icon;

  factory ActivityOption.fromJson(Map<dynamic, dynamic> data) {
    final type = data['type'] as String;
    final icon = data['icon'] as String;
    return ActivityOption(type: type, icon: icon);
  }

  toJson() {
    return {
      'type': type,
      'icon': icon,
    };
  }
}

class Entry {
  Entry(
      {required this.id,
      required this.date,
      required this.dateString,
      required this.activities});
  final String id;
  final int date;
  final String dateString;
  final List<Activity> activities;

  factory Entry.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final date = data['date'] as int;
    final d = date.toString();
    final dateString =
        '${d.substring(0, 4)}-${d.substring(4, 6)}-${d.substring(6, 8)}';
    final activities = data['activities'].map<Activity>((d) {
      return Activity.fromJson(d);
    }).toList();
    return Entry(
        id: id, date: date, dateString: dateString, activities: activities);
  }

  toJson() {
    return {
      'date': date,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  addActivity(String type) {
    return updateActivities([...activities, Activity(type: type, note: '')]);
  }

  setActivity(String type, String note) {
    final i = activities.indexWhere((a) => a.type == type);
    final updatedActivity = activities[i].updateNote(note);
    final activitiesCopy = [...activities];
    activitiesCopy[i] = updatedActivity;
    return updateActivities(activitiesCopy);
  }

  removeActivity(type) {
    final i = activities.indexWhere((a) => a.type == type);
    final activitiesCopy = [...activities];
    activitiesCopy.removeAt(i);
    return updateActivities(activities);
  }

  updateActivities(activities) {
    // final index = activities.indexWhere((a) => a.type == activity.type);
    // final nextActivities = [...activities];
    // nextActivities[index] = activity;
    return Entry(
      id: id,
      date: date,
      dateString: dateString,
      activities: activities,
    );
  }
}

class Database {
  final CollectionReference<Entry> _entryRef =
      FirebaseFirestore.instance.collection('entries').withConverter<Entry>(
            fromFirestore: (snapshot, _) {
              return Entry.fromJson({...snapshot.data()!, 'id': snapshot.id});
            },
            toFirestore: (entry, _) => entry.toJson(),
          );

  final CollectionReference<ActivityOption> _activityOptionRef =
      FirebaseFirestore.instance
          .collection('activityOptions')
          .withConverter<ActivityOption>(
            fromFirestore: (snapshot, _) {
              return ActivityOption.fromJson(
                  {...snapshot.data()!, 'id': snapshot.id});
            },
            toFirestore: (activityOption, _) => activityOption.toJson(),
          );

  // FOR LOCAL DEV
  void clear() async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
  }

  Stream get allEntries => _entryRef.snapshots();

  Stream entry(date) => _entryRef.where('date', isEqualTo: date).snapshots();

  Stream get activityOptions => _activityOptionRef.snapshots();

  Future<bool> editEntry(Entry entry) async {
    try {
      await _entryRef.doc(entry.id).update(entry.toJson());
      return true;
    } catch (e) {
      print(e);
      return Future.error(e); //return error
    }
  }
}

// Future<bool> editEntry(Entry e) {
//   entries = _firestore.collection('entries');
//   try {
//     await _movies.doc()
//   }
// };
