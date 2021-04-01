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
  }) : super(key: key);

  /// width item date
  final double width;
  final DateTime date;
  final bool isSelected;
  final String? locale;
  final DateSelectionCallback? onDateSelected;

  ///count appointments in day
  final int count;

  @override
  Widget build(BuildContext context) {
    String _date = DateFormat('E', 'vi').format(date).toUpperCase();
    return GestureDetector(
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(this.date);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 36,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? const Color(0xFF1A6DE3) : Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _date.replaceAll('H',''),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF858585),
                    fontSize: 9,
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF303030),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            count.toString(),
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1A6DE3)
                  : const Color(0xFF858585),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
