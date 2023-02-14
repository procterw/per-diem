import 'dart:math';

class Activity {
  Activity({required this.type, required this.note, required this.notePreview});
  final String type;
  final String note;
  final String notePreview;

  factory Activity.fromJson(Map<String, dynamic> data) {
    final type = data['type'] as String;
    final note = data['note'] as String;
    final notePreview = data['notePreview'] as String;
    return Activity(type: type, note: note, notePreview: notePreview);
  }

  getNotePreview() {
    final noteCopy = note;
    noteCopy.replaceAll("\n", " ");
    if (noteCopy.isEmpty) {
      return noteCopy;
    }
    return noteCopy.substring(
      0,
      min(100, noteCopy.length),
    );
  }

  toJson() {
    return {
      'type': type,
      'note': note,
      'notePreview': getNotePreview(),
    };
  }

  Activity updateNote(note) {
    return Activity(type: type, note: note, notePreview: notePreview);
  }
}
