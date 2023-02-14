import 'package:flutter/material.dart';
import './date_row.dart';
import '../models/entry.dart';

class DayList extends StatelessWidget {
  const DayList({
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
          return const SizedBox(height: 12);
        });
  }
}
