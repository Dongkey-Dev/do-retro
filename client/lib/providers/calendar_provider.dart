import 'package:flutter/material.dart';
import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'package:simple_todo/services/calendar_service.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarService _service;
  Map<String, List<CalendarEvent>> _eventCache = {};
  Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isLoading = false;
  String? _error;

  CalendarProvider({required CalendarService service}) : _service = service;

  bool get isLoading => _isLoading;
  String? get error => _error;

  String _getCacheKey(DateTime date) {
    return '${date.year}-${date.month}';
  }

  List<CalendarEvent> getEventsForDay(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _events[dateKey] ?? [];
  }

  Future<void> loadEventsForMonth(DateTime month) async {
    final key = _getCacheKey(month);

    // 이미 캐시에 있다면 스킵
    if (_eventCache.containsKey(key)) {
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final events = await _service.getEventsForMonth(month);
      _eventCache[key] = events;

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // 여러 달의 데이터를 한 번에 로드
  Future<void> preloadMonths(List<DateTime> months) async {
    try {
      await Future.wait(months.map((month) => loadEventsForMonth(month)));
    } catch (e) {
      print('Error preloading months: $e');
    }
  }

  Future<void> addEvent(CalendarEvent event) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Firestore에 이벤트 추가
      await _service.addEvent(
        date: event.date,
        categoryType: event.categoryType,
        subItemKey: event.subItemKey,
      );

      // 날짜를 키로 사용하기 위해 시간 정보 제거
      final dateKey = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );

      // _events 맵에 이벤트 추가
      if (_events[dateKey] == null) {
        _events[dateKey] = [];
      }
      _events[dateKey]!.add(event);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
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

  // 필요한 경우 이벤트 초기 로드 메서드
  Future<void> loadEvents(DateTime date) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 해당 월의 시작일과 마지막일을 계산
      final startOfMonth = DateTime(date.year, date.month, 1);
      final endOfMonth = DateTime(date.year, date.month + 1, 0);

      final events = await _service.getEvents(startOfMonth, endOfMonth);
      _events.clear();

      // 받아온 이벤트들을 날짜별로 분류
      for (var event in events) {
        final dateKey = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
        );

        if (_events[dateKey] == null) {
          _events[dateKey] = [];
        }
        _events[dateKey]!.add(event);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
