import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classes.dart';
import 'date_row.dart';
import 'mock_api.dart';

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

    // db.clear();

    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
        ),
        body: StreamBuilder(
            stream: db.allEntries,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show a CircularProgressIndicator when the stream is loading
              }
              if (snapshot.error != null) {
                return Center(
                    child: Text(
                        'Some error occurred')); // Show an error just in case(no internet etc)
              }

              final List<QueryDocumentSnapshot> entries = snapshot.data.docs;

              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final entry = entries[index].data() as Entry;
                  return DateRow(entry: entry);
                },
              );
            }));

    // ,ListView(
    //   children: _entries.map((entry) => DateRow(entry: entry)).toList()),
  }
}
