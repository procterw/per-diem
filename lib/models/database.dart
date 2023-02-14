import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './entry.dart';
import './activity_option.dart';

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

  Stream entries(startDate, endDate) => _entryRef
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThanOrEqualTo: endDate)
      .snapshots();

  Stream entry(date) => _entryRef.where('date', isEqualTo: date).snapshots();

  Stream get activityOptions => _activityOptionRef.snapshots();

  Future<bool> editEntry(Entry entry) async {
    try {
      if (entry.id == 'EMPTY') {
        await _entryRef.add(entry);
      } else {
        await _entryRef.doc(entry.id).set(entry);
      }
      return true;
    } catch (e) {
      return Future.error(e); //return error
    }
  }
}

final databaseProvider = Provider((ref) => Database());
