import 'package:flutter/material.dart';
import '../widgets/calendar/calendar_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void _handleDaySelected(DateTime date) {
    setState(() {
      selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      todayDate: selectedDate,
      onDaySelected: _handleDaySelected,
    );
  }
}
