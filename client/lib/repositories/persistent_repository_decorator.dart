import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'package:simple_todo/repositories/calendar_repository.dart';
import 'package:simple_todo/repositories/local_calendar_repository.dart';
import 'package:simple_todo/repositories/remote_calendar_repository.dart';

class PersistentRepositoryDecorator implements CalendarRepository {
  final CalendarRepository _remote;
  final LocalCalendarRepository _local;

  PersistentRepositoryDecorator({
    required CalendarRepository remote,
    required LocalCalendarRepository local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<List<CalendarEvent>> getEvents(DateTime start, DateTime end) async {
    try {
      if (_remote is RemoteCalendarRepository) {
        // 원격 저장소에서 데이터 가져오기
        final events = await _remote.getEvents(start, end);
        // 로컬에 동기화
        for (final event in events) {
          await _local.createEvent(
              event.date, event.categoryType, event.subItem);
        }
        return events;
      } else {
        // 로컬 저장소만 사용
        return await _local.getEvents(start, end);
      }
    } catch (e) {
      // 원격 저장소 실패 시 로컬 데이터 반환
      return await _local.getEvents(start, end);
    }
  }

  @override
  Future<CalendarEvent> createEvent(
    DateTime date,
    CategoryType categoryType,
    String subItem,
  ) async {
    // 먼저 로컬에 저장
    final localEvent = await _local.createEvent(date, categoryType, subItem);

    if (_remote is RemoteCalendarRepository) {
      try {
        // 원격 저장소에도 저장 시도
        return await _remote.createEvent(date, categoryType, subItem);
      } catch (e) {
        // 원격 저장 실패 시 로컬 이벤트 반환
        return localEvent;
      }
    }

    return localEvent;
  }

  @override
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) async {
    // 먼저 로컬 업데이트
    final localEvent = await _local.updateEvent(id, event);

    if (_remote is RemoteCalendarRepository) {
      try {
        // 원격 저장소 업데이트 시도
        return await _remote.updateEvent(id, event);
      } catch (e) {
        // 원격 업데이트 실패 시 로컬 이벤트 반환
        return localEvent;
      }
    }

    return localEvent;
  }

  @override
  Future<void> deleteEvent(String id) async {
    // 먼저 로컬에서 삭제
    await _local.deleteEvent(id);

    if (_remote is RemoteCalendarRepository) {
      try {
        // 원격 저장소에서도 삭제 시도
        await _remote.deleteEvent(id);
      } catch (e) {
        // 원격 삭제 실패는 무시
      }
    }
  }
}
