import 'package:flutter/material.dart';
import 'package:simple_todo/widgets/calendar/calendar_view.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final CalendarViewType viewType;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onTitleTapped;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.viewType,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTitleTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: GestureDetector(
            onTap: onTitleTapped,
            child: Text(
              '${currentMonth.year}.${currentMonth.month}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
