import 'package:dailylog/mock_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classes.dart';

// enum COLORS = {

// };

class ActivityIcon extends ConsumerWidget {
  const ActivityIcon({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder(
      stream: db.activityOptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final activityOptionDocs = snapshot.data!.docs.map((document) {
            ActivityOption data = document.data()! as ActivityOption;
            return data;
          }).toList();

          List<ActivityOption> activityOptions =
              List<ActivityOption>.from(activityOptionDocs);

          return Text(activityOptions.firstWhere((a) => a.type == type).icon,
              style: TextStyle(fontSize: 26));
        } else {
          return Text('LOADING');
        }
      },
    );
  }
}

class ActivityLabel extends ConsumerWidget {
  const ActivityLabel({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder(
      stream: db.activityOptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final activityOptionDocs = snapshot.data!.docs.map((document) {
            ActivityOption data = document.data()! as ActivityOption;
            return data;
          }).toList();

          List<ActivityOption> activityOptions =
              List<ActivityOption>.from(activityOptionDocs);

          // final color = activityOptions.firstWhere((a) => a.type == type).color;

          return Container(
              // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              // margin: const EdgeInsets.only(bottom: 4),
              // decoration: BoxDecoration(
              //   // color: Color.fromARGB(255, 246, 229, 218),
              //   borderRadius: BorderRadius.all(Radius.circular(20)),
              // ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(activityOptions.firstWhere((a) => a.type == type).icon,
                style: TextStyle(fontSize: 20)),
            Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
          ]));

          return Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
                text: TextSpan(
                    text:
                        activityOptions.firstWhere((a) => a.type == type).icon,
                    style: const TextStyle(fontSize: 18),
                    children: [
                  TextSpan(
                      text: type,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ])),
          );
        } else {
          return Text('LOADING');
        }
      },
    );
  }
}
