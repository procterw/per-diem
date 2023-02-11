import 'package:flutter/material.dart';
import 'dates.dart';
import 'classes.dart';
import 'entry_screen/entry_screen.dart';
import 'activity_label.dart';

class _DateHeader extends StatelessWidget {
  const _DateHeader({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          border: BorderDirectional(
              end: BorderSide(color: Colors.blueGrey.shade50)),
        ),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(getDayOfWeek(date),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // const SizedBox(width: 24),
              Text(getDate(date), style: const TextStyle(fontSize: 12)),
            ]));
  }
}

class ActivityPreview extends StatelessWidget {
  const ActivityPreview({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ActivityLabel(type: activity.type),
            Text(activity.note),
            // Flexible(child: Text(activity.note, overflow: TextOverflow.ellipsis)),
          ],
        ));
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

class _DateRowContent extends StatelessWidget {
  const _DateRowContent({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.blueGrey.shade200),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Colors.blueGrey.shade100.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1))
        ],
      ),
      child: InkWell(
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
            _DateHeader(date: entry.dateString),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.activities
                    .map((a) => ActivityPreview(activity: a))
                    .toList()),
            // Container(
            //     height: 16,
            //     decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //             begin: Alignment.topCenter,
            //             end: Alignment.bottomCenter,
            //             colors: [
            //           Colors.grey.shade50,
            //           Colors.grey.shade300,
            //         ])))
          ],
        ),
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
