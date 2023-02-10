import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylog/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classes.dart';
import 'date_row.dart';
import 'mock_api.dart';

class DateList extends StateNotifier<List<DateTime>> {
  DateList() : super([]) {
    generateDateList();
  }

  final DateTime anchorDate = DateTime.now();

  void generateDateList() {
    final List<DateTime> dateList = [];
    final d = anchorDate;
    for (var i = 25; i >= -10; i--) {
      dateList.add(d.subtract(Duration(days: i)));
    }
    state = dateList;
  }

  // when scrolling up, an earlier set of dates needs to be loaded
  void shiftEarlier() {}

  // when scrolling up, an later set of dates needs to be loaded
  void shiftLater() {}
}

final dateListProvider = StateNotifierProvider<DateList, List<DateTime>>((ref) {
  return DateList();
});

class DayListScreen extends ConsumerWidget {
  const DayListScreen({super.key});

//   @override
//   State<DayListScreen> createState() => _DayListState();
// }

// class _DayListState extends ConsumerState<DayListScreen> {
//   // List<Entry> _entries = [];

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   loadData('dates').then((d) {
//   //     _entries = d.map<Entry>((entry) => Entry.fromJson(entry)).toList();
//   //     setState(() {});
//   //   });
//   // }

  // Reads now return a Model instead of a Map
  // final List<Entry> testtest = await .doc('123').get().then((s) => s.data());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final dateList = ref.watch(dateListProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
        ),
        body: StreamBuilder(
            stream: db.allEntries,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show a CircularProgressIndicator when the stream is loading
              }
              if (snapshot.error != null) {
                return const Center(
                    child: Text(
                        'Some error occurred')); // Show an error just in case(no internet etc)
              }

              final entryDocs = snapshot.data!.docs.map((document) {
                Entry data = document.data()! as Entry;
                return data;
              }).toList();

              List<Entry> entries = List<Entry>.from(entryDocs);

              return ListView.builder(
                itemCount: dateList.length,
                itemBuilder: (BuildContext context, int index) {
                  final DateTime dateTime = dateList[index];
                  final int date = getDateId(dateTime);

                  try {
                    final entry =
                        entries.firstWhere((Entry e) => e.date == date);
                    return DateRow(entry: entry);
                  } catch (e) {
                    return EmptyDateRow(date: date);
                  }
                },
              );

              // return ListView.builder(
              //   itemCount: entries.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     final entry = entries[index].data() as Entry;
              //     return DateRow(entry: entry);
              //   },
              // );

              // return ListView.builder(
              //   itemCount: entries.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     final entry = entries[index].data() as Entry;
              //     return DateRow(entry: entry);
              //   },
              // );
            }));

    // ,ListView(
    //   children: _entries.map((entry) => DateRow(entry: entry)).toList()),
  }
}
