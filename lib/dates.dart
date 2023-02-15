import 'package:intl/intl.dart';

getDate(String dateString) {
  final parsedDate = DateTime.parse(dateString);
  return DateFormat.MMMd().format(parsedDate);
}

getDayOfWeek(String dateString) {
  final parsedDate = DateTime.parse(dateString);
  return DateFormat.E().format(parsedDate);
}

// getDayOfMonth(String dateString) {
//   final parsedDate = DateTime.parse(dateString);
// }

String getDateString(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10);
}

int getDateId(DateTime dateTime) {
  return int.parse(getDateString(dateTime).replaceAll('-', ''));
}

String getDayOfMonth(DateTime dateTime) {
  return DateFormat.d().format(dateTime);
}
