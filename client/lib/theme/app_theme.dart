import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      extensions: const [
        CalendarThemeData(
          selectedDayColor: Colors.blue,
          todayColor: Colors.orange,
          dayTextColor: Colors.black87,
          sundayTextColor: Colors.red,
          weekdayTextColor: Colors.black87,
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[850],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      extensions: [
        CalendarThemeData(
          selectedDayColor: Colors.blue,
          todayColor: Colors.orange,
          dayTextColor: Colors.white70,
          sundayTextColor: Colors.red.shade300,
          weekdayTextColor: Colors.white70,
        ),
      ],
    );
  }
}

// CalendarThemeData 클래스는 ThemeExtension을 상속받아야 함
class CalendarThemeData extends ThemeExtension<CalendarThemeData> {
  final Color selectedDayColor;
  final Color todayColor;
  final Color dayTextColor;
  final Color sundayTextColor;
  final Color weekdayTextColor;

  const CalendarThemeData({
    required this.selectedDayColor,
    required this.todayColor,
    required this.dayTextColor,
    required this.sundayTextColor,
    required this.weekdayTextColor,
  });

  @override
  ThemeExtension<CalendarThemeData> copyWith({
    Color? selectedDayColor,
    Color? todayColor,
    Color? dayTextColor,
    Color? sundayTextColor,
    Color? weekdayTextColor,
  }) {
    return CalendarThemeData(
      selectedDayColor: selectedDayColor ?? this.selectedDayColor,
      todayColor: todayColor ?? this.todayColor,
      dayTextColor: dayTextColor ?? this.dayTextColor,
      sundayTextColor: sundayTextColor ?? this.sundayTextColor,
      weekdayTextColor: weekdayTextColor ?? this.weekdayTextColor,
    );
  }

  @override
  ThemeExtension<CalendarThemeData> lerp(
    ThemeExtension<CalendarThemeData>? other,
    double t,
  ) {
    if (other is! CalendarThemeData) {
      return this;
    }
    return CalendarThemeData(
      selectedDayColor:
          Color.lerp(selectedDayColor, other.selectedDayColor, t)!,
      todayColor: Color.lerp(todayColor, other.todayColor, t)!,
      dayTextColor: Color.lerp(dayTextColor, other.dayTextColor, t)!,
      sundayTextColor: Color.lerp(sundayTextColor, other.sundayTextColor, t)!,
      weekdayTextColor:
          Color.lerp(weekdayTextColor, other.weekdayTextColor, t)!,
    );
  }
}

// Theme 확장
extension CalendarTheme on ThemeData {
  CalendarThemeData get calendarTheme =>
      extension<CalendarThemeData>() ??
      const CalendarThemeData(
        selectedDayColor: Colors.blue,
        todayColor: Colors.orange,
        dayTextColor: Colors.black87,
        sundayTextColor: Colors.red,
        weekdayTextColor: Colors.black87,
      );
}
