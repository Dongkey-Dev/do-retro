import 'package:simple_todo/models/category_data.dart';
import '../models/calendar_event.dart';

// 기본 인터페이스
abstract class CalendarRepository {
  Future<List<CalendarEvent>> getEvents(DateTime start, DateTime end);
  Future<CalendarEvent> createEvent(
      DateTime date, CategoryType categoryType, String subItem);
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event);
  Future<void> deleteEvent(String id);
}
