import 'package:date_picker_timeline_plugin/date_picker_timeline.dart';
import 'package:date_picker_timeline_plugin/date_picker_timeline_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _selectedValue = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  DateTime getDateByWeekNumber({int? week, int? year, bool? start}) {
    DateTime date;
    var days = ((week! - 1) * 7) + (start! ? -1 : 5);
    date = DateTime.utc(2021, 1, days);
    return date;
  }

  @override
  Widget build(BuildContext context) {
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
      locale: const Locale('vi'),
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
              counts: [1, 2, 3, 4, 5, 6, 7],
              onDateChange: (DateTime selectedDate) {
                setState(() {
                  _selectedValue = selectedDate;
                });
              },
              focusedDay: _focusedDay,
              onFocusedDateChange: (DateTime date) {
                _focusedDay = date;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                DateTime date =
                    getDateByWeekNumber(week: 12, year: 2021, start: true);
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                print(dateFormat.format(date));

                var dayOfWeek = 1;
                DateTime now = DateTime.now();
                var lastMonday = now
                    .subtract(Duration(days: now.weekday - dayOfWeek))
                    .toIso8601String();
                print(lastMonday);
                print(now.weekday.toString() + 'weekday');
                // DateUtils.firstDayOffset(2021, 3, Locale('vi'));
                int test1 = Utils.firstDayOffset(2021, 3);
                print(test1);
                int test2 = Utils.dateDelta(now, DateTime(2021, 4, 1));
                print(test2 / 7);
              },
              child: Text('test'),
            ),
            const SizedBox(height: 32),
            Text('You selected: \n $_selectedValue'),
            DateTimeRangeSelect(
              context: context,
              selectedFirstDate: DateTime.now(),
              selectedLastDate: DateTime.now(),
              focusedMonth: DateTime.now(),
              onFocusedDateChange: (date){
              },
            ),
          ],
        ),
      ),
    );
  }
}
