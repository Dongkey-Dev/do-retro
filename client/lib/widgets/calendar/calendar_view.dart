import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'calendar_header.dart';
import 'month_view.dart';
import 'calendar_todo_list.dart';

enum CalendarViewType {
  month,
  week,
}

class CalendarView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;

  const CalendarView({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return PieCanvas(
      theme: const PieTheme(
        overlayColor: Colors.black54,
        pointerSize: 0,
      ),
      child: Column(
        children: [
          CalendarHeader(
            viewType: CalendarViewType.month,
            currentMonth: selectedDate,
            onPreviousMonth: () {
              onDaySelected(
                DateTime(selectedDate.year, selectedDate.month - 1, 1),
              );
            },
            onNextMonth: () {
              onDaySelected(
                DateTime(selectedDate.year, selectedDate.month + 1, 1),
              );
            },
            onTitleTapped: () {
              // 월 선택 다이얼로그 표시 (선택사항)
              // showMonthPicker(context: context, ...);
            },
          ),
          const SizedBox(height: 8),
          MonthView(
            selectedDate: selectedDate,
            onDaySelected: onDaySelected,
            monthDate: DateTime(selectedDate.year, selectedDate.month, 1),
            heightFactor: const AlwaysStoppedAnimation(1.0),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CalendarTodoList(
              currentMonth: selectedDate,
            ),
          ),
        ],
      ),
    );
  }
}
