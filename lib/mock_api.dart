import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classes.dart';

loadData(String dataKey) async {
  final input = await rootBundle.loadString('assets/mock_data.json');
  final map = await json.decode(input);
  return map[dataKey] as List;
}

// Creating a simple Riverpod provider that provides an instance of our Database class so that it can be used from our UI(by calling Database class methods)
final databaseProvider = Provider((ref) => Database());
