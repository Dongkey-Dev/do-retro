import 'package:flutter/material.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/models/category_data.dart';

class CalendarEvent {
  final String id;
  final DateTime date;
  final CategoryType categoryType;
  final String subItemKey;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  CalendarEvent({
    required this.id,
    required this.date,
    required this.categoryType,
    required this.subItemKey,
    required this.createdAt,
    this.updatedAt,
    this.startTime,
    this.endTime,
  });

  String getLocalizedSubItem(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (subItemKey) {
      case 'subItemMorningExercise':
        return l10n.subItemMorningExercise;
      case 'subItemReading':
        return l10n.subItemReading;
      case 'subItemMeditation':
        return l10n.subItemMeditation;
      case 'subItemDiary':
        return l10n.subItemDiary;
      case 'subItemMeeting':
        return l10n.subItemMeeting;
      case 'subItemReport':
        return l10n.subItemReport;
      case 'subItemProject':
        return l10n.subItemProject;
      case 'subItemStudy':
        return l10n.subItemStudy;
      case 'subItemDeadline':
        return l10n.subItemDeadline;
      case 'subItemAppointment':
        return l10n.subItemAppointment;
      case 'subItemImportantMeeting':
        return l10n.subItemImportantMeeting;
      case 'subItemUrgentTask':
        return l10n.subItemUrgentTask;
      case 'subItemHobby':
        return l10n.subItemHobby;
      case 'subItemExercise':
        return l10n.subItemExercise;
      case 'subItemShopping':
        return l10n.subItemShopping;
      case 'subItemSelfDevelopment':
        return l10n.subItemSelfDevelopment;
      default:
        return subItemKey;
    }
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTimeOfDay(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return CalendarEvent(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      categoryType: CategoryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['categoryType'],
      ),
      subItemKey: json['subItemKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      startTime: parseTimeOfDay(json['startTime'] as String?),
      endTime: parseTimeOfDay(json['endTime'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    String? timeOfDayToString(TimeOfDay? time) {
      if (time == null) return null;
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    return {
      'id': id,
      'date': date.toIso8601String(),
      'categoryType': categoryType.name,
      'subItemKey': subItemKey,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'startTime': timeOfDayToString(startTime),
      'endTime': timeOfDayToString(endTime),
    };
  }

  CalendarEvent copyWith({
    String? id,
    DateTime? date,
    CategoryType? categoryType,
    String? subItemKey,
    DateTime? createdAt,
    DateTime? updatedAt,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      date: date ?? this.date,
      categoryType: categoryType ?? this.categoryType,
      subItemKey: subItemKey ?? this.subItemKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
