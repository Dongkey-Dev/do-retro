import 'package:flutter/material.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/models/calendar_settings.dart';

class CalendarUtils {
  static int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  static int getFirstWeekday(DateTime date, CalendarStartDay startDay) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    int weekday = firstDayOfMonth.weekday; // 1(월요일) ~ 7(일요일)

    if (startDay == CalendarStartDay.monday) {
      weekday = weekday - 1; // 0(월요일) ~ 6(일요일)
      if (weekday == -1) weekday = 6;
    } else {
      // 일요일 시작인 경우
      if (weekday == 7)
        weekday = 0; // 일요일은 0
      else
        weekday = weekday; // 나머지는 그대로 1~6 사용
    }

    return weekday;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static List<String> getWeekdayNames(
      BuildContext context, CalendarStartDay startDay) {
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

    if (startDay == CalendarStartDay.monday) {
      // 월요일부터 시작하도록 재정렬
      final sunday = weekdays.removeAt(0);
      weekdays.add(sunday);
    }

    return weekdays;
  }
}
