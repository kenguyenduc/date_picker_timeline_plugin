import 'package:date_picker_timeline_plugin/date_picker_timeline.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: DatePickerTimeline(
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime(2022),
            firstDate: DateTime(2019),
          ),
        ),
      ),
    );
  }
}
