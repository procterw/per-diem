import 'package:flutter/material.dart';
import 'dart:async';
import '../classes.dart';

Timer? _debounce;

class ActivityEditor extends StatefulWidget {
  const ActivityEditor(
      {super.key,
      required this.activity,
      required this.activityOptions,
      required this.onChanged});

  final Activity activity;
  final List<ActivityOption> activityOptions;
  final Function onChanged;

  @override
  State<ActivityEditor> createState() => _ActivityEditorState();
}

class _ActivityEditorState extends State<ActivityEditor> {
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
    return Column(children: [
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
            onChanged: (String note) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 1000), () {
                widget.onChanged(widget.activity.type, note);
              });
            },
          )),
    ]);
  }
}
