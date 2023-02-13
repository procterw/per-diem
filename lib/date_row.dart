import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'dates.dart';
import 'classes.dart';
import 'entry_screen/entry_screen.dart';
import 'activity_label.dart';

class _DateHeader extends StatelessWidget {
  const _DateHeader({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = getDayOfWeek(date);
    var bgColor = Colors.grey.shade300;
    if (dayOfWeek == 'Sat' || dayOfWeek == 'Sun') {
      bgColor = Colors.grey.shade600;
    }

    return Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border:
                BorderDirectional(end: BorderSide(color: bgColor, width: 4))),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(dayOfWeek,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        padding: EdgeInsets.symmetric(vertical: 4),
        // color: Colors.grey.shade100,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ActivityIcon(type: activity.type),
          const SizedBox(width: 8, height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(activity.type,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                activity.notePreview,
                maxLines: 1,
                style: TextStyle(overflow: TextOverflow.fade),
              ),
              // Flexible(
              //     child: Text(
              //   activity.notePreview,
              //   maxLines: 1,
              //   style: TextStyle(overflow: TextOverflow.fade),
              // )),
              // Flexible(child: Text(activity.note, overflow: TextOverflow.ellipsis)),
            ],
          )
        ]));
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return EntryScreen(date: entry.date);
          }),
        );
      },
      // child: IntrinsicHeight( child:
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateHeader(date: entry.dateString),
          Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.activities
                      .map((a) => ActivityPreview(activity: a))
                      .toList())),
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
