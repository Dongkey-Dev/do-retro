import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'package:simple_todo/repositories/calendar_repository.dart';

class CalendarService {
  final CalendarRepository repository;

  CalendarService({required this.repository});

  // 캐시 관리
  final Map<String, List<CalendarEvent>> _cache = {};

  Future<List<CalendarEvent>> getEvents(DateTime start, DateTime end) async {
    try {
      // 캐시 키 생성 (년-월 형식)
      final cacheKey = '${start.year}-${start.month}';

      // 캐시된 데이터가 있으면 반환
      if (_cache.containsKey(cacheKey)) {
        final cachedEvents = _cache[cacheKey]!;
        return cachedEvents.where((event) {
          return !event.date.isBefore(start) && !event.date.isAfter(end);
        }).toList();
      }

      // 저장소에서 데이터 가져오기
      final events = await repository.getEvents(start, end);

      // 캐시에 저장
      _cache[cacheKey] = events;

      return events;
    } catch (e) {
      print('Error getting events: $e'); // 디버깅용
      rethrow;
    }
  }

  Future<CalendarEvent> addEvent({
    required DateTime date,
    required CategoryType categoryType,
    required String subItem,
  }) async {
    try {
      // 저장소에 이벤트 추가
      final event = await repository.createEvent(date, categoryType, subItem);

      // 캐시 업데이트
      final cacheKey = '${date.year}-${date.month}';
      _cache[cacheKey] ??= [];
      _cache[cacheKey]!.add(event);

      return event;
    } catch (e) {
      print('Error adding event: $e'); // 디버깅용
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await repository.deleteEvent(eventId);
  }

  // 캐시 무효화
  void invalidateCache() {
    _cache.clear();
  }

  // 특정 월의 캐시만 무효화
  void invalidateCacheForMonth(DateTime month) {
    final cacheKey = '${month.year}-${month.month}';
    _cache.remove(cacheKey);
  }

  Future<List<CalendarEvent>> getEventsForMonth(DateTime month) async {
    try {
      // 해당 월의 시작일과 마지막일 계산
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0);

      // 캐시 키 생성 (년-월 형식)
      final cacheKey = '${month.year}-${month.month}';

      // 캐시된 데이터가 있으면 반환
      if (_cache.containsKey(cacheKey)) {
        print('Returning cached events for $cacheKey'); // 디버깅용
        return _cache[cacheKey]!;
      }

      print('Fetching events for $cacheKey'); // 디버깅용

      // 저장소에서 해당 월의 이벤트 가져오기
      final events = await repository.getEvents(start, end);

      // 캐시에 저장
      _cache[cacheKey] = events;

      print('Fetched ${events.length} events for $cacheKey'); // 디버깅용
      return events;
    } catch (e) {
      print('Error getting events for month: $e'); // 디버깅용
      rethrow;
    }
  }

  // 이전 달과 다음 달의 데이터를 미리 로드 (선택적)
  Future<void> preloadAdjacentMonths(DateTime month) async {
    final prevMonth = DateTime(month.year, month.month - 1);
    final nextMonth = DateTime(month.year, month.month + 1);

    // 비동기로 동시에 로드
    await Future.wait([
      getEventsForMonth(prevMonth),
      getEventsForMonth(nextMonth),
    ]);
  }

  // 캐시 상태 확인 (디버깅용)
  void printCacheStatus() {
    print('Current cache status:');
    _cache.forEach((key, events) {
      print('$key: ${events.length} events');
    });
  }
}
