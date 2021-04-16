import 'package:date_picker_timeline_plugin/date_picker_timeline_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'gestures/tap.dart';
import 'dart:math' as math;

const double _kDayPickerRowHeight = 44.0;
const int _kMaxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(_kDayPickerRowHeight,
        constraints.viewportMainAxisExtent / (_kMaxDayPickerRowCount + 1));
    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      mainAxisStride: tileHeight,
      crossAxisStride: tileWidth,
      childMainAxisExtent: tileHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _kDayPickerGridDelegate = _DayPickerGridDelegate();

class DateTimeRangeSelect extends StatefulWidget {
  DateTimeRangeSelect(
      {Key? key,
      required this.context,
      this.initialSelectedFirstDate,
      this.initialSelectedLastDate,
      required this.firstDate,
      required this.lastDate,
      this.onChanged,
      required this.focusedMonth,
      required this.onFocusedDateChange})
      : assert(!lastDate.isBefore(firstDate),
            'lastDate $lastDate must be on or after firstDate $firstDate.'),
        assert(
            initialSelectedFirstDate == null ||
                !initialSelectedFirstDate.isBefore(firstDate),
            'initialDate $initialSelectedFirstDate must be on or after firstDate $firstDate.'),
        assert(
            initialSelectedFirstDate == null ||
                !initialSelectedFirstDate.isAfter(lastDate),
            'initialDate $initialSelectedFirstDate must be on or before lastDate $lastDate.'),
        assert(
            initialSelectedLastDate == null ||
                !initialSelectedLastDate.isBefore(firstDate),
            'initialDate $initialSelectedLastDate must be on or after firstDate $firstDate.'),
        assert(
            initialSelectedLastDate == null ||
                !initialSelectedLastDate.isAfter(lastDate),
            'initialDate $initialSelectedLastDate must be on or before lastDate $lastDate.'),
        super(key: key);

  @override
  DateTimeRangeSelectState createState() => DateTimeRangeSelectState();

  final BuildContext context;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? initialSelectedFirstDate;
  final DateTime? initialSelectedLastDate;

  /// Called when the user picks a month.
  final ValueChanged<DateTimeRange>? onChanged;

  /// Ngày trong tháng đang được hiển thị
  final DateTime focusedMonth;

  ///ngày trong tháng hiển thị thay được thay đổi
  final DateChangeListener onFocusedDateChange;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;
}

class DateTimeRangeSelectState extends State<DateTimeRangeSelect> {
  DateTime? _selectedFirstDate;
  DateTime? _selectedLastDate;
  late DateTime _focusedMonth;
  SelectableDayPredicate? selectableDayPredicate;
  DateTime _dateTimeNow = DateTime.now();

  TagTime _tagTimeSelected = TagTime.none;

  @override
  void initState() {
    super.initState();
    _focusedMonth =
        DateTime(widget.focusedMonth.year, widget.focusedMonth.month);
    _selectedFirstDate = widget.initialSelectedFirstDate;
    _selectedLastDate = widget.initialSelectedLastDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildTagsTime(),
          SizedBox(
            height: 300,
            child: _buildDayPicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtonTagTime(
            title: 'Hôm nay',
            value: TagTime.today,
            onPressed: _handleButtonTodayPressed,
          ),
          const SizedBox(width: 12),
          _buildButtonTagTime(
            title: 'Tuần này',
            value: TagTime.thisWeek,
            onPressed: _handleButtonThisWeekPressed,
          ),
          const SizedBox(width: 12),
          _buildButtonTagTime(
            title: 'Tháng này',
            value: TagTime.thisMonth,
            onPressed: _handleButtonThisMonthPressed,
          ),
        ],
      ),
    );
  }

  void _handleUpdateOnChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(DateTimeRange(
          start: Utils.dateOnly(_selectedFirstDate!),
          end: Utils.dateOnly(_selectedLastDate!)));
    }
    widget.onFocusedDateChange(Utils.dateOnly(_focusedMonth));
  }

  void _handleButtonTodayPressed() {
    setState(() {
      _tagTimeSelected = TagTime.today;
      _selectedFirstDate = _dateTimeNow;
      _selectedLastDate = _dateTimeNow;
      if (!Utils.isSameMonth(_focusedMonth, _dateTimeNow)) {
        _focusedMonth = _dateTimeNow;
      }
    });
    _handleUpdateOnChanged();
  }

  void _handleButtonThisWeekPressed() {
    setState(() {
      _tagTimeSelected = TagTime.thisWeek;
      _selectedFirstDate = Utils.getMondayOnCurrentWeek(_dateTimeNow);
      _selectedLastDate = _selectedFirstDate!.add(Duration(days: 6));
      if (!Utils.isSameMonth(_focusedMonth, _dateTimeNow)) {
        _focusedMonth = _dateTimeNow;
      }
    });
    _handleUpdateOnChanged();
  }

  void _handleButtonThisMonthPressed() {
    setState(() {
      _tagTimeSelected = TagTime.thisMonth;
      _selectedFirstDate = DateTime(_dateTimeNow.year, _dateTimeNow.month);
      _selectedLastDate = DateTime(_dateTimeNow.year, _dateTimeNow.month,
          Utils.getDaysInMonth(_dateTimeNow.year, _dateTimeNow.month));
      if (!Utils.isSameMonth(_focusedMonth, _dateTimeNow)) {
        _focusedMonth = _dateTimeNow;
      }
    });
    _handleUpdateOnChanged();
  }

  Widget _buildButtonTagTime({
    required String title,
    VoidCallback? onPressed,
    required TagTime value,
  }) {
    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: value == _tagTimeSelected
              ? const Color(0xFF1A6DE3)
              : const Color(0xFFEEEEEE),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: value == _tagTimeSelected
                ? Colors.white
                : const Color(0xFF858585),
          ),
        ),
      ),
    );
  }

  ///Load page view next month
  void handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
        widget.onFocusedDateChange(Utils.dateOnly(_focusedMonth));
      });
    }
  }

  ///Load page view previous month
  void handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);

        widget.onFocusedDateChange(Utils.dateOnly(_focusedMonth));
      });
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_focusedMonth
        .isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_focusedMonth
        .isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  /// Computes the offset from the first day of week that the first day of the
  /// [month] falls on.
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
  int _computeFirstDayOffset(int year, int month) {
    // 0-based day of week, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;
    // 0-based day of week, with 0 representing Sunday.
    final int firstDayOfWeekFromSunday = 1;
    // firstDayOfWeekFromSunday recomputed to be Monday-based
    final int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;
    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the 1-st of the month.
    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  Widget _buildDayPicker() {
    final int year = _focusedMonth.year;
    final int month = _focusedMonth.month;
    final int daysInMonth = Utils.getDaysInMonth(year, month);
    final int firstDayOffset = _computeFirstDayOffset(year, month);
    final List<Widget> labels = <Widget>[];
    labels.addAll(_getDayHeaders());
    for (int i = 0; true; i += 1) {
      // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
      // a leap year.
      final int day = i - firstDayOffset + 1;
      if (day > daysInMonth) break;
      if (day < 1) {
        labels.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool disabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate) ||
            (selectableDayPredicate != null &&
                !selectableDayPredicate!(dayToBuild));
        BoxDecoration? decoration;
        _HighlightPainter? highlightPainter;
        TextStyle? itemStyle = TextStyle(
          color: Color(0xFF303030),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
        final bool isRangeSelected =
            _selectedFirstDate != null && _selectedLastDate != null;
        bool isSelectedFirstDay = false;
        if (_selectedFirstDate != null) {
          isSelectedFirstDay = _selectedFirstDate!.year == year &&
              _selectedFirstDate!.month == month &&
              _selectedFirstDate!.day == day;
        }
        bool isSelectedLastDay = false;
        if (_selectedLastDate != null) {
          isSelectedLastDay = _selectedLastDate!.year == year &&
              _selectedLastDate!.month == month &&
              _selectedLastDate!.day == day;
        }
        bool isInRange = false;
        if (_selectedLastDate != null && _selectedFirstDate != null) {
          isInRange = (dayToBuild.isBefore(_selectedLastDate!) &&
              dayToBuild.isAfter(_selectedFirstDate!));
        }

        if (isSelectedFirstDay || isSelectedLastDay) {
          // The selected start and end dates gets a circle background
          // highlight, and a contrasting text color.
          itemStyle = itemStyle.copyWith(color: Colors.white);
          decoration = BoxDecoration(
            color: Color(0xFF1A6DE3),
            borderRadius: BorderRadius.circular(16.0),
          );
          if (isRangeSelected &&
              !Utils.isSameDay(_selectedFirstDate, _selectedLastDate)) {
            final _HighlightPainterStyle style = isSelectedFirstDay
                ? _HighlightPainterStyle.highlightTrailing
                : _HighlightPainterStyle.highlightLeading;
            highlightPainter = _HighlightPainter(
              color: Color(0xFFEDF4FF),
              style: style,
            );
          }
        } else if (isInRange) {
          // The days within the range get a light background highlight.
          highlightPainter = _HighlightPainter(
            color: Color(0xFFEDF4FF),
            style: _HighlightPainterStyle.highlightAll,
          );
          if (_dateTimeNow.year == year &&
              _dateTimeNow.month == month &&
              _dateTimeNow.day == day) {
            decoration = BoxDecoration(
              border: Border.all(color: Color(0xFF1A6DE3), width: 1),
              borderRadius: BorderRadius.circular(16.0),
            );
          }
        } else if (_dateTimeNow.year == year &&
            _dateTimeNow.month == month &&
            _dateTimeNow.day == day) {
          decoration = BoxDecoration(
            border: Border.all(color: Color(0xFF1A6DE3), width: 1),
            borderRadius: BorderRadius.circular(16.0),
          );
        }

        Widget dayWidget = Container(
          decoration: decoration,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Center(
            child: Text(
              dayToBuild.day.toString(),
              style: itemStyle,
            ),
          ),
        );

        if (highlightPainter != null) {
          dayWidget = CustomPaint(
            painter: highlightPainter,
            child: dayWidget,
          );
        }
        if (!disabled) {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DateTime? first, last;
              _handleRefreshTagTime();
              if (_selectedLastDate != null) {
                first = dayToBuild;
                last = null;
              } else {
                if (_selectedFirstDate != null &&
                    Utils.isSameMonth(_selectedFirstDate, dayToBuild)) {
                  if (dayToBuild.compareTo(_selectedFirstDate!) <= 0) {
                    first = dayToBuild;
                    last = _selectedFirstDate;
                  } else {
                    first = _selectedFirstDate;
                    last = dayToBuild;
                  }
                } else {
                  first = dayToBuild;
                  last = null;
                }
              }
              _handleDayChanged([first, last]);
            },
            child: dayWidget,
          );
        }

        labels.add(dayWidget);
      }
    }
    return Dismissible(
      key: UniqueKey(),
      resizeDuration: null,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          handleNextMonth();
        } else if (direction == DismissDirection.startToEnd) {
          handlePreviousMonth();
        }
      },
      child: GridView.custom(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: _kDayPickerGridDelegate,
        padding: EdgeInsets.all(10),
        childrenDelegate:
            SliverChildListDelegate(labels, addRepaintBoundaries: false),
      ),
    );
  }

  void _handleRefreshTagTime() {
    setState(() {
      _tagTimeSelected = TagTime.none;
    });
  }

  ///Lấy giá trị ngày đã chọn
  void _handleDayChanged(List<DateTime?> changes) {
    assert(changes.length == 2);
    _selectedFirstDate = changes[0];
    _selectedLastDate = changes[1];
    setState(() {});
    if (_selectedFirstDate != null &&
        _selectedLastDate != null &&
        widget.onChanged != null) {
      widget.onChanged!(DateTimeRange(
          start: Utils.dateOnly(_selectedFirstDate!),
          end: Utils.dateOnly(_selectedLastDate!)));
    }
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// T2 T3 T4 T5 T6 T7 CN
  /// _  _  _  _  1  2  3
  /// 4  5  6  7  8  9  10
  /// ```
  List<Widget> _getDayHeaders() {
    TextStyle _headerStyle = TextStyle(
      color: Color(0xFF858585),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
    final List<Widget> result = <Widget>[];
    List<String> _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    for (int i = 0; i < 7; i++) {
      result.add(Center(child: Text(_weekdays[i], style: _headerStyle)));
    }
    return result;
  }
}

enum TagTime { none, today, thisWeek, thisMonth }

/// Determines which style to use to paint the highlight.
enum _HighlightPainterStyle {
  /// Paints nothing.
  none,

  /// Paints a rectangle that occupies the leading half of the space.
  highlightLeading,

  /// Paints a rectangle that occupies the trailing half of the space.
  highlightTrailing,

  /// Paints a rectangle that occupies all available space.
  highlightAll,
}

/// This custom painter will add a background highlight to its child.
///
/// This highlight will be drawn depending on the [style], [color], and
/// [textDirection] supplied. It will either paint a rectangle on the
/// left/right, a full rectangle, or nothing at all. This logic is determined by
/// a combination of the [style] and [textDirection].
class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    required this.color,
    this.style = _HighlightPainterStyle.none,
  });

  final Color color;
  final _HighlightPainterStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Rect rectLeft = Rect.fromLTWH(0, 0, size.width / 2, size.height);
    final Rect rectRight =
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height);

    switch (style) {
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(
          rectRight,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightLeading:
        canvas.drawRect(
          rectLeft,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
        break;
      case _HighlightPainterStyle.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
