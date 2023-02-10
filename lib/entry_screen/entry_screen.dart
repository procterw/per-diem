import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './activity_editor.dart';
import './activity_selector.dart';
import './entry_header.dart';
import '../classes.dart';
import '../mock_api.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key, required this.date});

  final int date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder(
        stream: db.entry(date),
        builder: (entryContext, entrySnapshot) {
          return StreamBuilder(
              stream: db.activityOptions,
              builder: (activityContext, activitySnapshot) {
                if (entrySnapshot.hasData && activitySnapshot.hasData) {
                  final entry = entrySnapshot.data.docs[0].data();

                  final test = activitySnapshot.data!.docs.map((document) {
                    ActivityOption data = document.data()! as ActivityOption;
                    return data;
                  }).toList();

                  List<ActivityOption> activityOptions =
                      List<ActivityOption>.from(test);

                  return Scaffold(
                    appBar: AppBar(title: EntryHeader(entry: entry)),
                    body: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      children: [
                        ...entry.activities
                            .map((a) => ActivityEditor(
                                  activityOptions: activityOptions,
                                  activity: a,
                                  onChanged: (type, note) {
                                    db.editEntry(entry.setActivity(type, note));
                                  },
                                ))
                            .toList(),
                        ActivitySelector(
                            entry: entry,
                            activityOptions: activityOptions,
                            onAdd: (type) {
                              db.editEntry(entry.addActivity(type));
                            })
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              });
        });
  }
}
