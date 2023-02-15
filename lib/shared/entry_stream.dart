import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/database.dart';
import '../models/entry.dart';

class EntryStream extends ConsumerWidget {
  const EntryStream({
    super.key,
    required this.dateRange,
    required this.onFoo,
  });

  final List<dynamic> dateRange;
  final Function onFoo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder(
        stream: db.entries(dateRange.first, dateRange.last),
        // stream: db.allEntries,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a CircularProgressIndicator when the stream is loading
          }
          if (snapshot.error != null) {
            return const Center(
                child: Text(
                    'Some error occurred')); // Show an error just in case(no internet etc)
          }

          print('data');
          print(snapshot.data!.docs);

          final entryDocs = snapshot.data!.docs.map((document) {
            Entry data = document.data()! as Entry;
            return data;
          }).toList();

          List<Entry> entries = List<Entry>.from(entryDocs);

          return onFoo(entries);
        });
  }
}
