import 'package:date_picker_timeline_plugin/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    DateTime _selectedValue = DateTime.now();
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('vi'),
      ],
      home: Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            DatePickerTimeline(
              context: context,
              initialDate: DateTime.now(),
              lastDate: DateTime(2022),
              firstDate: DateTime(2019),
              onDateChange: (DateTime selectedDate) {
                setState(() {
                  _selectedValue = selectedDate;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2022),
                  locale: Locale('vi'),
                );
              },
              child: Text('test'),
            ),
            const SizedBox(height: 32),
            Text('You selected: \n $_selectedValue'),
          ],
        ),
      ),
    );
  }
}
