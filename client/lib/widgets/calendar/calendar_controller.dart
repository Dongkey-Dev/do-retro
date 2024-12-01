import 'package:flutter/material.dart';

class CalendarController {
  final Map<int, DateTime> monthCache = {};
  late DateTime currentMonth;
  late PageController pageController;
  final int initialPage = 1000;

  CalendarController(DateTime selectedDate) {
    currentMonth = DateTime(selectedDate.year, selectedDate.month);
    pageController = PageController(
      initialPage: initialPage,
      keepPage: true,
    );
    monthCache[initialPage] = currentMonth;
  }

  void preloadMonths(int currentPage) {
    DateTime baseMonth = monthCache[currentPage] ?? currentMonth;

    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (!monthCache.containsKey(i)) {
        monthCache[i] = DateTime(
          baseMonth.year,
          baseMonth.month + (i - currentPage),
        );
      }
    }

    monthCache.removeWhere(
        (key, value) => key < currentPage - 1 || key > currentPage + 1);
  }

  DateTime getMonthForPage(int page) {
    if (!monthCache.containsKey(page)) {
      final monthDiff = page - initialPage;
      return DateTime(
        currentMonth.year,
        currentMonth.month + monthDiff,
      );
    }
    return monthCache[page]!;
  }

  void dispose() {
    pageController.dispose();
  }
}
