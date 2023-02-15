import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailylog/dates.dart';

class Week {
  final List<DateTime> _dayList;
  final bool _isFirstWeek;

  addDay(day) {
    _dayList.add(day);
  }

  get first => _dayList.first;
  get last => _dayList.last;

  get isFirstWeek => _isFirstWeek;
  get dayList => _dayList;

  Week(this._dayList, this._isFirstWeek);
}

class Month {
  final int year;
  final int month;
  final List<Week> weekList;
  // a month is a list of weeks

  Month._(this.year, this.month, this.weekList);

  get weeks {
    return weekList;
  }

  get monthString => DateFormat.MMMM().format(weekList.first.first);
  get yearString => DateFormat.y().format(weekList.first.first);

  get firstDay => getDateId(weekList.first.first);
  get lastDay => getDateId(weekList.last.last);

  // get monthString => DateFormat.M(firstDay);

  factory Month(year, month) {
    final List<Week> weekList = [Week([], true)];
    int dayIncrement = 0;
    int weekIncrement = 0;
    while (true) {
      dayIncrement = dayIncrement + 1;
      final d = DateTime(year, month, dayIncrement);
      if (d.month != month) break;
      weekList[weekIncrement].addDay(d);
      if (DateFormat.E().format(d) == 'Sun') {
        weekIncrement = weekIncrement + 1;
        weekList.add(Week([], false));
      }
    }
    return Month._(year, month, weekList);
  }
}

class Calendar {
  final List<Month> monthList;

  get dateRange {
    return [
      monthList.last.firstDay,
      monthList.first.lastDay,
    ];
  }

  get months {
    return monthList;
  }

  Calendar(this.monthList);
}

class CalendarNotifier extends StateNotifier<Calendar> {
  CalendarNotifier() : super(Calendar([])) {
    generateCalendar();
    _scrollTimer = Timer(const Duration(milliseconds: 0), () {});
  }

  int monthOffset = 3;
  Timer? _scrollTimer;

  generateCalendar() {
    final List<Month> monthList = [];
    final d = DateTime.now();
    for (var i = 0; i <= monthOffset; i++) {
      final dd = DateTime(d.year, d.month - i, 1);
      monthList.add(Month(dd.year, dd.month));
    }
    // state = Calendar(List.from(monthList.reversed));
    state = Calendar(monthList);
  }

  loadMoreMonths() {
    if (_scrollTimer!.isActive) return;
    _scrollTimer = Timer(const Duration(milliseconds: 400), () {});
    monthOffset = monthOffset + 2;
    generateCalendar();
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, Calendar>((ref) {
  return CalendarNotifier();
});

// import 'dart:async';
// import 'package:dailylog/dates.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DateList extends StateNotifier<List<int>> {
//   DateList() : super([]) {
//     generateDateList();
//     _scrollTimer = Timer(const Duration(milliseconds: 0), () {});
//   }

//   int dateOffsetBack = 21;
//   DateTime anchorDate = DateTime.now();
//   Timer? _scrollTimer;

//   void generateDateList() {
//     final List<DateTime> dateList = [];
//     final d = anchorDate;
//     for (var i = 0; i <= dateOffsetBack; i++) {
//       dateList.add(d.subtract(Duration(days: i)));
//     }
//     state = dateList.map((d) => getDateId(d)).toList();
//     // state.reversed;
//   }

//   // when scrolling up, an earlier set of dates needs to be loaded
//   void loadOlderDays() {
//     if (_scrollTimer!.isActive) return;
//     _scrollTimer = Timer(const Duration(milliseconds: 200), () {});
//     dateOffsetBack = dateOffsetBack + 14;
//     generateDateList();
//   }
// }

// final dateListProvider = StateNotifierProvider<DateList, List<int>>((ref) {
//   return DateList();
// });
