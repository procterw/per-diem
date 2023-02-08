import 'package:intl/intl.dart';

getDate(String dateString) {
  final parsedDate = DateTime.parse(dateString);
  return DateFormat.MMMd().format(parsedDate);
}

getDayOfWeek(String dateString) {
  final parsedDate = DateTime.parse(dateString);
  return DateFormat.EEEE().format(parsedDate);
}
