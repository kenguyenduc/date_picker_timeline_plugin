import 'dart:core';

import 'package:flutter/material.dart';

/// Utility functions for working with dates.
class Utils {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  Utils._();

  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime normalizeDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day, 12);
  }

  /// Returns a [DateTimeRange] with the dates of the original, but with times
  /// set to midnight.
  ///
  /// See also:
  ///  * [dateOnly], which does the same thing for a single date.
  static DateTimeRange datesOnly(DateTimeRange range) {
    return DateTimeRange(
        start: dateOnly(range.start), end: dateOnly(range.end));
  }

  /// Returns true if the two [DateTime] objects have the same day, month, and
  /// year, or are both null.
  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  /// Returns true if the two [DateTime] objects have the same month and
  /// year, or are both null.
  static bool isSameMonth(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year && dateA?.month == dateB?.month;
  }

  /// Determines the number of months between two [DateTime] objects.
  ///
  /// For example:
  /// ```
  /// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
  /// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
  /// int delta = monthDelta(date1, date2);
  /// ```
  ///
  /// The value for `delta` would be `7`.
  static int monthDelta(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  /// Returns a [DateTime] that is [monthDate] with the added number
  /// of months and the day set to 1 and time set to midnight.
  ///
  /// For example:
  /// ```
  /// DateTime date = DateTime(year: 2019, month: 1, day: 15);
  /// DateTime futureDate = DateUtils.addMonthsToMonthDate(date, 3);
  /// ```
  ///
  /// `date` would be January 15, 2019.
  /// `futureDate` would be April 1, 2019 since it adds 3 months.
  static DateTime addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) {
    return DateTime(monthDate.year, monthDate.month + monthsToAdd);
  }

  /// Returns a [DateTime] with the added number of days and time set to
  /// midnight.
  static DateTime addDaysToDate(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }

  /// Computes the offset from the first day of the week that the first day of
  /// the [month] falls on.
  ///
  /// For example, September 1, 2017 falls on a Friday, which in the calendar
  /// localized for United States English appears as:
  ///
  /// ```
  /// S M T W T F S
  /// _ _ _ _ _ 1 2
  /// ```
  ///
  /// The offset for the first day of the months is the number of leading blanks
  /// in the calendar, i.e. 5.
  ///
  /// The same date localized for the Russian calendar has a different offset,
  /// because the first day of week is Monday rather than Sunday:
  ///
  /// ```
  /// M T W T F S S
  /// _ _ _ _ 1 2 3
  /// ```
  ///
  /// So the offset is 4, rather than 5.
  ///
  /// This code consolidates the following:
  ///
  /// - [DateTime.weekday] provides a 1-based index into days of week, with 1
  ///   falling on Monday.
  /// - [MaterialLocalizations.firstDayOfWeekIndex] provides a 0-based index
  ///   into the [MaterialLocalizations.narrowWeekdays] list.
  /// - [MaterialLocalizations.narrowWeekdays] list provides localized names of
  ///   days of week, always starting with Sunday and ending with Saturday.
  ///   Kiểm tra ngày đầu tiên của tháng nằnm ở đâu
  ///   Default localizations.firstDayOfWeekIndex = 1  (Monday)
  ///   0 1 2 3 4 5 6
  ///   2 3 4 5 6 7 CN
  static int firstDayOffset(int year, int month) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    // 0-based start of week depending on the locale, with 0 representing Sunday.
    // int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;
    int firstDayOfWeekIndex = 1;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  /// Returns the number of days in a month, according to the proleptic
  /// Gregorian calendar.
  ///
  /// This applies the leap year logic introduced by the Gregorian reforms of
  /// 1582. It will not give valid results for dates prior to that time.
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  /// Lấy ngày thứ 2 đầu tiên của tuần hiện tại
  static DateTime getMondayOnCurrentWeek(DateTime date) {
    const int _dayOfWeek = 1;
    return date.subtract(Duration(days: date.weekday - _dayOfWeek));
  }

  /// Lấy ngày đầu tiên của tháng
  static DateTime getFirstDateOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Lấy ngày cuối của tháng
  static DateTime getLastDateOfMonth(DateTime date) {
    final int _year = date.year;
    final int _month = date.month;
    return DateTime(_year, _month, getDaysInMonth(_year, _month));
  }

  ///Days Between Dates
  static int dateDelta(DateTime startDate, DateTime endDate) {
    return startDate.difference(endDate).inDays;
  }
}
