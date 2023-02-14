import 'package:flutter/material.dart';
import '../activity_label.dart';
import '../models/activity.dart';

class ActivityPreview extends StatelessWidget {
  const ActivityPreview({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          ActivityIcon(type: activity.type),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity.type,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                activity.notePreview,
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ],
          ))
        ]));
  }
}
