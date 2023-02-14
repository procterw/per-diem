import 'package:dailylog/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'classes.dart';
import 'date_row.dart';
import 'mock_api.dart';

class DateList extends StateNotifier<List<int>> {
  DateList() : super([]) {
    generateDateList();
    _scrollTimer = Timer(const Duration(milliseconds: 0), () {});
  }

  int dateOffsetBack = 21;
  DateTime anchorDate = DateTime.now();
  Timer? _scrollTimer;

  void generateDateList() {
    final List<DateTime> dateList = [];
    final d = anchorDate;
    for (var i = 0; i <= dateOffsetBack; i++) {
      dateList.add(d.subtract(Duration(days: i)));
    }
    state = dateList.map((d) => getDateId(d)).toList();
    // state.reversed;
  }

  // when scrolling up, an earlier set of dates needs to be loaded
  void loadOlderDays() {
    if (_scrollTimer!.isActive) return;
    _scrollTimer = Timer(const Duration(milliseconds: 200), () {});
    dateOffsetBack = dateOffsetBack + 14;
    generateDateList();
  }
}

final dateListProvider = StateNotifierProvider<DateList, List<int>>((ref) {
  return DateList();
});

class DayListScreen extends ConsumerWidget {
  const DayListScreen({super.key});

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

          return _DayList(dateList: dateList, entries: entries);
        });
  }
}

class _DayList extends StatelessWidget {
  const _DayList({
    super.key,
    required this.dateList,
    required this.entries,
  });

  final List<int> dateList;
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: dateList.length,
        itemBuilder: (BuildContext context, int index) {
          final int date = dateList[index];

          try {
            final entry = entries.firstWhere((Entry e) => e.date == date);
            return DateRow(entry: entry);
          } catch (e) {
            return EmptyDateRow(date: date);
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 12);
        });
  }
}
