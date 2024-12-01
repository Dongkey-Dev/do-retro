import 'package:flutter/material.dart';
import 'calendar_day_cell.dart';
import 'calendar_utils.dart';

class WeekView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;
  final Animation<double> heightFactor;

  const WeekView({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
    required this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final availableHeight =
        size.height - padding.top - padding.bottom - kToolbarHeight - 48;

    final cellWidth = (size.width - 40 - (6 * 8)) / 7;
    final cellHeight = availableHeight / 6;
    final childAspectRatio = cellWidth / cellHeight;

    final weekStart =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return AnimatedBuilder(
      animation: heightFactor,
      builder: (context, child) {
        return Container(
          alignment: Alignment.topCenter,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              final currentDate = weekStart.add(Duration(days: index));
              return CalendarDayCell(
                date: currentDate,
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              );
            },
          ),
        );
      },
    );
  }
}
