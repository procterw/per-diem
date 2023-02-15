import 'package:dailylog/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar.dart';
import '../models/entry.dart';
import '../shared/entry_stream.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarProvider);

    print('test');
    print(calendar.dateRange);
    print(calendar.months);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;

              if (metrics.pixels > metrics.maxScrollExtent - 100) {
                ref.read(calendarProvider.notifier).loadMoreMonths();
              }
              return true;
            },
            // child: Text('foo')));
            child: EntryStream(
                dateRange: calendar.dateRange,
                onFoo: (List<Entry> entries) {
                  // print(entries);
                  // return Text('oh boy!');
                  return CalendarView(calendar: calendar);
                })));
  }
}

class CalendarView extends StatelessWidget {
  const CalendarView({super.key, required this.calendar});

  final Calendar calendar;

  @override
  Widget build(BuildContext context) {
    // return Text('here we go');
    return ListView.builder(
      reverse: true,
      itemCount: calendar.months.length,
      itemBuilder: (context, index) {
        return MonthView(month: calendar.months[index]);
      },
    );
  }
}

class MonthView extends StatelessWidget {
  const MonthView({super.key, required this.month});
  final Month month;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(),
            child: Row(children: [
              Text(month.monthString,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(month.yearString, style: TextStyle(fontSize: 16)),
            ])),
        Column(
          children: month.weeks.map<Widget>((Week week) {
            final alignment = week.isFirstWeek
                ? MainAxisAlignment.end
                : MainAxisAlignment.start;
            return Row(
              mainAxisAlignment: alignment,
              children: week.dayList.map<Widget>((DateTime day) {
                return DayCell(day: day);
              }).toList(),
            );
          }).toList(),
        )
      ]),
    );
  }
}

class DayCell extends StatelessWidget {
  const DayCell({super.key, required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      width: MediaQuery.of(context).size.width / 7 - 4,
      height: 60,
      // decoration: BoxDecoration(),
      child: Text(getDayOfMonth(day),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
