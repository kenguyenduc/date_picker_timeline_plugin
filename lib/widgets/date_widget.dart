import 'package:date_picker_timeline_plugin/date_picker_timeline_plugin.dart';
import 'package:date_picker_timeline_plugin/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key? key,
    this.width = 28,
    required this.date,
    required this.count,
    this.isSelected = false,
    this.locale,
    this.onDateSelected,
    this.isCurrentMonth = true,
  }) : super(key: key);

  /// width item date
  final double width;
  final DateTime date;
  final bool isSelected;
  final String? locale;
  final DateSelectionCallback? onDateSelected;
  final bool isCurrentMonth;

  ///count appointments in day
  final int? count;

  @override
  Widget build(BuildContext context) {
    const Color _colorDisable = Color(0xFF858585);
    return GestureDetector(
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(date);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? const Color(0xFF1A6DE3) : Colors.white,
                border: !isSelected && Utils.isSameDay(DateTime.now(), date)
                    ? Border.all(width: 1, color: const Color(0xFF1A6DE3))
                    : null),
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  DateFormat('E', 'vi').format(date).replaceAll('h', ''),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isCurrentMonth
                        ? const Color(0xFF858585)
                        : _colorDisable,
                    fontSize: 9,
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isCurrentMonth
                        ? const Color(0xFF303030)
                        : _colorDisable,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            count == null ? '' : count.toString(),
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1A6DE3)
                  : isCurrentMonth
                  ? const Color(0xFF858585)
                  : _colorDisable,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
