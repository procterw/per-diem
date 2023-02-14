import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './date_list.dart';
import '../models/date_list.dart';
import '../models/database.dart';
import '../models/entry.dart';

class DateListScreen extends ConsumerWidget {
  const DateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateList = ref.watch(dateListProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;

              if (metrics.pixels > metrics.maxScrollExtent - 100) {
                ref.read(dateListProvider.notifier).loadOlderDays();
              }
              return true;
            },
            child: _EntryStream(dateList: dateList)));
  }
}

class _EntryStream extends ConsumerWidget {
  const _EntryStream({
    super.key,
    required this.dateList,
  });

  final List<int> dateList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    // db.clear();

    return StreamBuilder(
        stream: db.entries(dateList.last, dateList.first),
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

          final entryDocs = snapshot.data!.docs.map((document) {
            Entry data = document.data()! as Entry;
            return data;
          }).toList();

          List<Entry> entries = List<Entry>.from(entryDocs);

          return DayList(dateList: dateList, entries: entries);
        });
  }
}
