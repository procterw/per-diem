import 'package:flutter/material.dart';
import '../dates.dart';
import '../classes.dart';

class EntryHeader extends StatelessWidget {
  const EntryHeader({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Text(
        '${getDayOfWeek(entry.dateString)} ${getDate(entry.dateString)}');
  }
}
