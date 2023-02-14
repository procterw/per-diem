import './activity.dart';

class Entry {
  Entry(
      {required this.id,
      required this.date,
      required this.dateString,
      required this.activities});
  final String id;
  final int date;
  final String dateString;
  final List<Activity> activities;

  factory Entry.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final date = data['date'] as int;
    final d = date.toString();
    final dateString =
        '${d.substring(0, 4)}-${d.substring(4, 6)}-${d.substring(6, 8)}';
    final activities = data['activities'].map<Activity>((d) {
      return Activity.fromJson(d);
    }).toList();
    return Entry(
        id: id, date: date, dateString: dateString, activities: activities);
  }

  factory Entry.empty(date) {
    final d = date.toString();
    final dateString =
        '${d.substring(0, 4)}-${d.substring(4, 6)}-${d.substring(6, 8)}';
    return Entry(
      id: 'EMPTY',
      date: date,
      dateString: dateString,
      activities: [],
    );
  }

  toJson() {
    return {
      'date': date,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  addActivity(String type) {
    return updateActivities(
        [...activities, Activity(type: type, note: '', notePreview: '')]);
  }

  setActivity(String type, String note) {
    final i = activities.indexWhere((a) => a.type == type);
    final updatedActivity = activities[i].updateNote(note);
    final activitiesCopy = [...activities];
    activitiesCopy[i] = updatedActivity;
    return updateActivities(activitiesCopy);
  }

  removeActivity(type) {
    final i = activities.indexWhere((a) => a.type == type);
    final activitiesCopy = [...activities];
    activitiesCopy.removeAt(i);
    return updateActivities(activities);
  }

  updateActivities(activities) {
    return Entry(
      id: id,
      date: date,
      dateString: dateString,
      activities: activities,
    );
  }
}
