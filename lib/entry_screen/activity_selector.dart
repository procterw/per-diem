import 'package:flutter/material.dart';
import '../classes.dart';

class ActivitySelector extends StatelessWidget {
  const ActivitySelector(
      {super.key,
      required this.onAdd,
      required this.activityOptions,
      required this.entry});

  final Function onAdd;
  final List<ActivityOption> activityOptions;
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 8,
        children: activityOptions
            // Filter out activities that already have entries
            .where((a) {
          for (Activity ea in entry.activities) {
            if (a.type == ea.type) return false;
          }
          return true;
        }).map<OutlinedButton>((a) {
          return OutlinedButton(
            onPressed: () => onAdd(a.type),
            child: RichText(
                text: TextSpan(
                    text: a.icon,
                    // style: TextStyle(fontSize: 18),
                    children: [
                  TextSpan(
                    text: a.type,
                  )
                ])),
          );
        }).toList());
  }
}
