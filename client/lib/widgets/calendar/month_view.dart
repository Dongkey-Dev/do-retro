import 'package:flutter/material.dart';
import 'package:simple_todo/theme/app_theme.dart';
import 'calendar_day_cell.dart';
import 'calendar_utils.dart';
import 'package:simple_todo/l10n/app_localizations.dart';

class MonthView extends StatelessWidget {
  final DateTime monthDate;
  final DateTime? selectedDate;
  final Function(DateTime) onDaySelected;

  const MonthView({
    super.key,
    required this.monthDate,
    required this.onDaySelected,
    required this.selectedDate,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 30,
          child: _buildWeekdayNames(context),
        ),
        const SizedBox(height: 8),
        Flexible(
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
            itemCount: _calculateItemCount(),
            itemBuilder: (context, index) => _buildMonthViewCell(index),
          ),
        ),
      ],
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

  Widget _buildWeekdayNames(BuildContext context) {
    final calendarTheme = Theme.of(context).calendarTheme;
    final l10n = AppLocalizations.of(context)!;

    final weekdays = [
      l10n.weekdaySun,
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: day == l10n.weekdaySun
                    ? calendarTheme.sundayTextColor
                    : calendarTheme.weekdayTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
