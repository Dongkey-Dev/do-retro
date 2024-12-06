import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/exceptions/calendar_exception.dart';
import 'package:simple_todo/models/calendar_event.dart';
import 'package:simple_todo/models/category_data.dart';
import 'calendar_repository.dart';

class RemoteCalendarRepository implements CalendarRepository {
  final Dio dio;
  final String baseUrl;

  RemoteCalendarRepository({required this.baseUrl})
      : dio = Dio()..options.baseUrl = baseUrl;

  @override
  Future<List<CalendarEvent>> getEvents(DateTime start, DateTime end) async {
    try {
      final response = await dio.get(
        '/events',
        queryParameters: {
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        },
      );

      return (response.data as List)
          .map((json) => CalendarEvent.fromJson(json))
          .toList();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 401:
          throw CalendarAuthException(
            '인증에 실패했습니다',
            error: e,
            stackTrace: e.stackTrace,
          );
        case 404:
          throw CalendarNotFoundException(
            '요청한 데이터를 찾을 수 없습니다',
            error: e,
            stackTrace: e.stackTrace,
          );
        default:
          throw CalendarNetworkException(
            '서버와 통신 중 오류가 발생했습니다',
            error: e,
            stackTrace: e.stackTrace,
          );
      }
    }
  }

  @override
  Future<CalendarEvent> createEvent(
    DateTime date,
    CategoryType categoryType,
    String subItem, {
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        '/events',
        data: {
          'date': date.toIso8601String(),
          'categoryType': categoryType.name,
          'subItem': subItem,
          'description': description,
        },
      );

      return CalendarEvent.fromJson(response.data);
    } on DioException catch (e) {
      throw CalendarNetworkException(
        '이벤트 생성 중 오류가 발생했습니다',
        error: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  @override
  Future<void> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }

  // updateEvent와 deleteEvent도 비슷한 방식으로 구현
}
