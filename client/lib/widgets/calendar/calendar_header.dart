import 'package:flutter/material.dart';
import 'package:simple_todo/widgets/calendar/calendar_view.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final CalendarViewType viewType;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.viewType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 연월 표시
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${currentMonth.year}.${currentMonth.month}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 요일 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['일', '월', '화', '수', '목', '금', '토']
                .map((day) => Text(
                      day,
                      style: TextStyle(
                        color: day == '일' ? Colors.red : Colors.black,
                        fontSize: 16,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
