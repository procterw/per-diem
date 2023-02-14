import 'package:flutter/material.dart';
import 'dart:async';
import '../classes.dart';
import '../activity_label.dart';

Timer? _debounce;

class ActivityEditor extends StatefulWidget {
  const ActivityEditor(
      {super.key, required this.activity, required this.onChanged});

  final Activity activity;
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
      ActivityLabel(type: widget.activity.type),
      Container(
          margin: const EdgeInsets.only(bottom: 8),
          color: Theme.of(context).canvasColor,
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
