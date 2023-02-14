import 'package:flutter/material.dart';
import './activity_preview.dart';
import '../models/entry.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    if (entry.activities.isEmpty) {
      return const SizedBox(height: 45);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entry.activities.length,
      itemBuilder: (context, index) {
        return ActivityPreview(activity: entry.activities[index]);
      },
    );
  }
}
