import 'package:flutter/material.dart';
import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'package:simple_todo/services/calendar_service.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarService _service;

  CalendarProvider({required CalendarService service}) : _service = service {
    // 초기화 시 데이터 로드
    _loadInitialData();
  }

  // 현재 로드된 이벤트들
  Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CalendarEvent> getEventsForDay(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _events[key] ?? [];
  }

  Future<void> loadEventsForMonth(DateTime month) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final events = await _service.getEventsForMonth(month);

      // 이벤트를 날짜별로 그룹화
      _events = {};
      for (final event in events) {
        final key = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
        );
        _events[key] ??= [];
        _events[key]!.add(event);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(
      DateTime date, CategoryType categoryType, String subItem) async {
    try {
      final event = await _service.addEvent(
        date: date,
        categoryType: categoryType,
        subItem: subItem,
      );

      // 로컬 상태 업데이트
      final key = DateTime(date.year, date.month, date.day);
      _events[key] ??= [];
      _events[key]!.add(event);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      print('Loading initial data...'); // 디버깅용 로그
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);

      final events = await _service.getEvents(start, end);
      print('Loaded ${events.length} events'); // 디버깅용 로그

      // 이벤트를 날짜별로 그룹화
      _events.clear();
      for (final event in events) {
        final key = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
        );
        _events[key] ??= [];
        _events[key]!.add(event);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading initial data: $e'); // 디버깅용 로그
    }
  }

  List<CalendarEvent> getAllEventsForMonth(DateTime month) {
    final events = <CalendarEvent>[];

    _events.forEach((date, dateEvents) {
      if (date.year == month.year && date.month == month.month) {
        events.addAll(dateEvents);
      }
    });

    // 날짜순으로 정렬
    events.sort((a, b) => a.date.compareTo(b.date));

    return events;
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _service.deleteEvent(eventId);

      // 로컬 상태에서 이벤트 제거
      _events.forEach((date, events) {
        events.removeWhere((event) => event.id == eventId);
      });
      // 빈 날짜 제거
      _events.removeWhere((date, events) => events.isEmpty);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
