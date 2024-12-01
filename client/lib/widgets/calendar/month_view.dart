import 'package:flutter/material.dart';
import 'calendar_day_cell.dart';
import 'calendar_utils.dart';

class MonthView extends StatelessWidget {
  final DateTime monthDate;
  final DateTime selectedDate;
  final Animation<double> heightFactor;
  final Function(DateTime) onDaySelected;

  const MonthView({
    super.key,
    required this.monthDate,
    required this.selectedDate,
    required this.heightFactor,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final availableHeight =
        size.height - padding.top - padding.bottom - kToolbarHeight - 48;

    final cellWidth = (size.width - 40 - (6 * 8)) / 7;
    final cellHeight = availableHeight / 12;
    final childAspectRatio = cellWidth / cellHeight;

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
              crossAxisSpacing: 8, // 가로 간격
              mainAxisSpacing: 8, // 세로 간격
            ),
            itemCount: _calculateItemCount(),
            itemBuilder: (context, index) => _buildMonthViewCell(index),
          ),
        );
      },
    );
  }

  Widget _buildMonthViewCell(int index) {
    if (index < CalendarUtils.getFirstWeekday(monthDate)) {
      return const SizedBox();
    }

    final day = index - CalendarUtils.getFirstWeekday(monthDate) + 1;
    if (day > CalendarUtils.getDaysInMonth(monthDate)) {
      return const SizedBox();
    }

    final currentDate = DateTime(monthDate.year, monthDate.month, day);

    return CalendarDayCell(
      date: currentDate,
      selectedDate: selectedDate,
      onDaySelected: onDaySelected,
    );
  }

  int _calculateItemCount() {
    return CalendarUtils.getDaysInMonth(monthDate) +
        CalendarUtils.getFirstWeekday(monthDate);
  }
}
