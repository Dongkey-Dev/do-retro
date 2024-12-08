import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/models/calendar_settings.dart';

class SettingsProvider extends ChangeNotifier {
  CalendarStartDay _startDay = CalendarStartDay.sunday;
  bool _useMarkdown = false;

  CalendarStartDay get startDay => _startDay;
  bool get useMarkdown => _useMarkdown;

  void setStartDay(CalendarStartDay startDay) {
    _startDay = startDay;
    notifyListeners();
  }

  Future<void> toggleMarkdown(bool value) async {
    _useMarkdown = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_markdown', value);
    notifyListeners();
  }

  // SharedPreferences를 사용하여 설정 저장/로드
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final startDayIndex = prefs.getInt('calendar_start_day') ?? 0;
    _startDay = CalendarStartDay.values[startDayIndex];
    _useMarkdown = prefs.getBool('use_markdown') ?? false;
    notifyListeners();
  }

  Future<void> saveStartDay(CalendarStartDay startDay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendar_start_day', startDay.index);
    setStartDay(startDay);
  }
}
