import 'package:flutter/material.dart';
import 'dates.dart';
import 'classes.dart';
import 'entry_screen/entry_screen.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.grey.shade200,
              Colors.grey.shade50,
            ])),
        child: Row(children: [
          const SizedBox(width: 24),
          Text(getDate(date),
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(getDayOfWeek(date)),
        ]));
  }
}

class ActivityPreview extends StatelessWidget {
  const ActivityPreview({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(width: 16, color: Colors.orange.shade500))),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(activity.type,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Flexible(
                child: Text(activity.note, overflow: TextOverflow.ellipsis)),
          ],
        ));
  }
}

class DateRow extends StatelessWidget {
  const DateRow({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return EntryScreen(date: entry.date);
            }),
          );
        },
        child: Column(
          children: [
            DateHeader(date: entry.dateString),
            Column(
                children: entry.activities
                    .map((a) => ActivityPreview(activity: a))
                    .toList()),
          ],
        ),
      ),
    );
  }
}
