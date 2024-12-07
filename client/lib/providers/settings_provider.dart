import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/models/calendar_settings.dart';

class SettingsProvider extends ChangeNotifier {
  CalendarStartDay _startDay = CalendarStartDay.sunday;

  CalendarStartDay get startDay => _startDay;

  void setStartDay(CalendarStartDay startDay) {
    _startDay = startDay;
    notifyListeners();
  }

  // SharedPreferences를 사용하여 설정 저장/로드
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final startDayIndex = prefs.getInt('calendar_start_day') ?? 0;
    _startDay = CalendarStartDay.values[startDayIndex];
    notifyListeners();
  }

  Future<void> saveStartDay(CalendarStartDay startDay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendar_start_day', startDay.index);
    setStartDay(startDay);
  }
}
