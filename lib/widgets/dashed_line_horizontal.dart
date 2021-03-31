import 'package:flutter/material.dart';

///UI draw dashed line horizontal
class DashedLineHorizontal extends StatelessWidget {
  const DashedLineHorizontal({
    this.height = 1,
    this.width = 8,
    this.color = const Color(0xFFEEEEEE),
  });

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double boxWidth = constraints.constrainWidth();
        final double dashWidth = width;
        final double dashHeight = height;
        final int dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
