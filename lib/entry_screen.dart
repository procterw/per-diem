import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dates.dart';
import 'classes.dart';
import 'mock_api.dart';

class ActivitySelector extends StatelessWidget {
  const ActivitySelector(
      {super.key,
      required this.onAdd,
      required this.activityOptions,
      required this.entry});

  final Function onAdd;
  final List<ActivityDef> activityOptions;
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
            onPressed: onAdd(a.type),
            child: RichText(
                text: TextSpan(text: a.icon, children: [
              TextSpan(
                  text: a.type,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))
            ])),
          );
        }).toList());
  }
}

class ActivityInput extends StatefulWidget {
  const ActivityInput(
      {super.key, required this.activity, required this.activityOptions});

  final Activity activity;
  final List<ActivityDef> activityOptions;

  @override
  State<ActivityInput> createState() => _ActivityInputState();
}

class _ActivityInputState extends State<ActivityInput> {
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.activity.note);
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dismissible(
        //   key: Key(widget.activity.type),
        //   onDismissed: (d) => print(d),
        //   background: Container(color: Colors.red),
        //   child: Container(
        //       padding: EdgeInsets.all(8), child: Text(widget.activity.type)),
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: RichText(
              // text: widget.activity.
              text: TextSpan(
                  text: widget.activityOptions
                      .firstWhere((a) => a.type == widget.activity.type)
                      .icon,
                  style: const TextStyle(fontSize: 18),
                  children: [
                TextSpan(
                    text: widget.activity.type,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
              ])),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade100,
            child: TextField(
              controller: contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Talk about it',
              ),
              onSubmitted: (String value) {
                print(value);
              },
            )),
      ],
    );
  }
}

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ActivityDef>> activityOptions =
        ref.watch(activityDefProvider);

    return activityOptions.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (activityOptions) {
          return Scaffold(
              appBar: AppBar(
                title: Text(getDayOfWeek(entry.dateString) +
                    ' ' +
                    getDate(entry.dateString)),
              ),
              body: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: [
                  ...entry.activities
                      // .where(isActivityTaken)
                      .map((a) => ActivityInput(
                          activityOptions: activityOptions, activity: a))
                      .toList(),
                  ActivitySelector(
                      entry: entry,
                      activityOptions: activityOptions,
                      onAdd: (v) => print(v)),
                ],
              ));
        });
  }
}
