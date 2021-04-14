import 'package:flutter/material.dart';
import 'gestures/tap.dart';

class DateTimeRangeSelect extends StatefulWidget {
  const DateTimeRangeSelect(
      {Key? key,
      required this.context,
      required this.selectedFirstDate,
      required this.selectedLastDate,
      this.onChanged,
      required this.focusedMonth,
      required this.onFocusedDateChange})
      : super(key: key);

  @override
  _DateTimeRangeSelectState createState() => _DateTimeRangeSelectState();

  final BuildContext context;

  ///
  /// This date is highlighted in the picker.
  final DateTime selectedFirstDate;
  final DateTime selectedLastDate;

  /// Called when the user picks a month.
  // final ValueChanged<List<DateTime?>> onChanged;
  final ValueChanged<DateTimeRange>? onChanged;

  /// Ngày trong tuần đang được hiển thị
  final DateTime focusedMonth;

  ///ngày trong thang hiển thị thay được thay đổi
  final DateChangeListener onFocusedDateChange;
}

class _DateTimeRangeSelectState extends State<DateTimeRangeSelect> {
  DateTime? _selectedFirstDate;
  DateTime? _selectedLastDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTagTime(),
          _buildDayPicker(),
        ],
      ),
    );
  }

  Widget _buildDayPicker() {
    return Container();
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

  Widget _buildTagTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButtonTagTime(
            title: 'Hôm nay', isSelected: true, onPressed: () {}),
        const SizedBox(width: 12),
        _buildButtonTagTime(
            title: 'Tuần này', isSelected: false, onPressed: () {}),
        const SizedBox(width: 12),
        _buildButtonTagTime(
            title: 'Tháng này', isSelected: false, onPressed: () {}),
      ],
    );
  }

  Widget _buildButtonTagTime({
    required String title,
    bool isSelected = false,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 28,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary:
              isSelected ? const Color(0xFF1A6DE3) : const Color(0xFFEEEEEE),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF858585),
          ),
        ),
      ),
    );
  }
}

enum TagTime { none, today, thisWeek, thisMonth }
