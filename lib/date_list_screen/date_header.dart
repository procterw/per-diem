import 'package:flutter/material.dart';
import '../dates.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = getDayOfWeek(date);

    // var bgColor = Colors.grey.shade200;
    // if (dayOfWeek == 'Sat' || dayOfWeek == 'Sun') {
    //   bgColor = Colors.grey.shade300;
    // }

    return Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(children: [
          Text(dayOfWeek,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(getDate(date), style: const TextStyle(fontSize: 11)),
        ]));
  }
}
