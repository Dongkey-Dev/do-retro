import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/exceptions/calendar_exception.dart';
import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'calendar_repository.dart';

class LocalCalendarRepository implements CalendarRepository {
  final SharedPreferences prefs;
  final _uuid = const Uuid();
  static const String _storageKey = 'calendar_events';

  LocalCalendarRepository({required this.prefs});

  Map<String, CalendarEvent>? _eventsCache;

  Future<Map<String, CalendarEvent>> _loadEvents() async {
    if (_eventsCache != null) return _eventsCache!;

    final String? jsonStr = prefs.getString(_storageKey);
    print('Loaded JSON: $jsonStr');

    if (jsonStr == null) {
      _eventsCache = {};
      return {};
    }

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      _eventsCache = jsonMap.map((key, value) {
        return MapEntry(
          key,
          CalendarEvent.fromJson(value as Map<String, dynamic>),
        );
      });
      print('Loaded events: ${_eventsCache?.length}');
      return _eventsCache!;
    } catch (e) {
      print('Error loading events: $e');
      _eventsCache = {};
      return {};
    }
  }

  Future<void> _saveEvents(Map<String, CalendarEvent> events) async {
    _eventsCache = events;
    final jsonMap = events.map((key, value) => MapEntry(key, value.toJson()));
    final jsonStr = json.encode(jsonMap);
    print('Saving JSON: $jsonStr');
    await prefs.setString(_storageKey, jsonStr);
  }

  @override
  Future<List<CalendarEvent>> getEvents(DateTime start, DateTime end) async {
    final events = await _loadEvents();
    final filteredEvents = events.values.where((event) {
      return !event.date
              .isBefore(DateTime(start.year, start.month, start.day)) &&
          !event.date.isAfter(DateTime(end.year, end.month, end.day));
    }).toList();
    print('Retrieved events: ${filteredEvents.length}');
    return filteredEvents;
  }

  @override
  Future<CalendarEvent> createEvent(
    DateTime date,
    CategoryType categoryType,
    String subItem,
  ) async {
    final events = await _loadEvents();
    final id = _uuid.v4();

    final event = CalendarEvent(
      id: id,
      date: date,
      categoryType: categoryType,
      subItem: subItem,
      createdAt: DateTime.now(),
    );

    events[id] = event;
    await _saveEvents(events);
    print('Created event: $id');
    return event;
  }

  @override
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) async {
    final events = await _loadEvents();
    if (!events.containsKey(id)) {
      throw CalendarNotFoundException('Event not found with id: $id');
    }

    events[id] = event.copyWith(updatedAt: DateTime.now());
    await _saveEvents(events);
    return events[id]!;
  }

  @override
  Future<void> deleteEvent(String id) async {
    final events = await _loadEvents();
    if (!events.containsKey(id)) {
      throw CalendarNotFoundException('Event not found with id: $id');
    }

    events.remove(id);
    await _saveEvents(events);
  }
}