import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key? key,
    this.width = 28,
    required this.date,
    required this.count,
    required this.onTap,
    this.isSelected = false,
    this.locale,
  }) : super(key: key);

  /// width item date
  final double width;
  final DateTime date;
  final bool isSelected;
  final GestureTapCallback onTap;
  final String? locale;
  ///count appointments in day
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? const Color(0xFF1A6DE3) : Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              child: Column(
                children: <Widget>[
                  Text(
                    //T2
                    DateFormat('E', locale).format(date).toUpperCase(),
                    style: TextStyle(
                      color:
                      isSelected ? Colors.white : const Color(0xFF858585),
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color:
                      isSelected ? Colors.white : const Color(0xFF303030),
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
      ),
    );
  }
}
