import 'package:flutter/material.dart';
import '../entry_screen/entry_screen.dart';
import './date_header.dart';
import './activity_list.dart';
import '../models/entry.dart';

class _DateRowContent extends StatelessWidget {
  const _DateRowContent({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return EntryScreen(date: entry.date);
          }),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateHeader(date: entry.dateString),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: ActivityList(entry: entry),
          ))
        ],
      ),
    );
  }
}

class DateRow extends StatelessWidget {
  const DateRow({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return _DateRowContent(entry: entry);
  }
}

class EmptyDateRow extends StatelessWidget {
  const EmptyDateRow({super.key, required this.date});

  final int date;

  @override
  Widget build(BuildContext context) {
    final Entry entry = Entry.empty(date);
    return _DateRowContent(entry: entry);
  }
}
