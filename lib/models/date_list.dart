import 'dart:async';
import 'package:dailylog/dates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateList extends StateNotifier<List<int>> {
  DateList() : super([]) {
    generateDateList();
    _scrollTimer = Timer(const Duration(milliseconds: 0), () {});
  }

  int dateOffsetBack = 21;
  DateTime anchorDate = DateTime.now();
  Timer? _scrollTimer;

  void generateDateList() {
    final List<DateTime> dateList = [];
    final d = anchorDate;
    for (var i = 0; i <= dateOffsetBack; i++) {
      dateList.add(d.subtract(Duration(days: i)));
    }
    state = dateList.map((d) => getDateId(d)).toList();
    // state.reversed;
  }

  // when scrolling up, an earlier set of dates needs to be loaded
  void loadOlderDays() {
    if (_scrollTimer!.isActive) return;
    _scrollTimer = Timer(const Duration(milliseconds: 200), () {});
    dateOffsetBack = dateOffsetBack + 14;
    generateDateList();
  }
}

final dateListProvider = StateNotifierProvider<DateList, List<int>>((ref) {
  return DateList();
});
