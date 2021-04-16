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
  DateTimeRange? dateTimeRange;
  bool isShowDateTimeRangeSelect = false;

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomDatePicker(
                context: context,
                initialDate: DateTime.now(),
                lastDate: DateTime(2030),
                firstDate: DateTime(2010),
                counts: [1, 2, 3, 4, 5, 6, 7],
                isShowDateTimeRange: isShowDateTimeRangeSelect,
                onShowDateTimeRangeChange: (value) {
                  setState(() {
                    isShowDateTimeRangeSelect = value;
                  });
                },
                onDateChange: (DateTime selectedDate) {
                  setState(() {
                    _selectedValue = selectedDate;
                  });
                  print('onDateTimeRangeChanged' + selectedDate.toString());
                },
                onDateTimeRangeChanged: (value) {
                  print('onDateTimeRangeChanged' + value.toString());
                },
                focusedDay: _focusedDay,
                onFocusedDateChange: (DateTime date) {
                  _focusedDay = date;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isShowDateTimeRangeSelect = !isShowDateTimeRangeSelect;
                  });
                },
                child: Text('test'),
              ),
              const SizedBox(height: 32),
              Text(
                'You selected: \n $_selectedValue \n dsadasda: \n $dateTimeRange\n $isShowDateTimeRangeSelect',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildDatePicker() {
  //   return DatePickerTimeline(
  //     context: context,
  //     initialDate: _dateTimeNow,
  //     firstDate: DateTime(_dateTimeNow.year - 5, 1),
  //     lastDate: DateTime(_dateTimeNow.year + 5, 12),
  //     focusedDay: _focusedDay,
  //     counts: state is AppointmentsCountSuccess ? state.counts : null,
  //     onDateChange: (DateTime selectedDate) {
  //       if (!Utils.isSameDay(_selectedDate, selectedDate)) {
  //         setState(() {
  //           if (_isExpandedAll) {
  //             _isExpandedAll = false;
  //           }
  //           _selectedDate = selectedDate;
  //           _appointmentsBloc.add(AppointmentsRefreshed(
  //               dateFrom: selectedDate, dateTo: selectedDate));
  //         });
  //       }
  //     },
  //     onFocusedDateChange: (DateTime dateTime) {
  //       _focusedDay = dateTime;
  //       if (_timerHandleDatePicker != null) {
  //         _timerHandleDatePicker?.cancel();
  //       }
  //       _timerHandleDatePicker = Timer(
  //         const Duration(milliseconds: 200),
  //         () => _appointmentsCountBloc.add(
  //           AppointmentsCountLoaded(Utils.getMondayOnCurrentWeek(_focusedDay)),
  //         ),
  //       );
  //     },
  //   );
  // }
}
