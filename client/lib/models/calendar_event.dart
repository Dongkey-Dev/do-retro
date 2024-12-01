import 'package:simple_todo/models/category_data.dart';

class CalendarEvent {
  final String id;
  final DateTime date;
  final CategoryType categoryType;
  final String subItem;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CalendarEvent({
    required this.id,
    required this.date,
    required this.categoryType,
    required this.subItem,
    required this.createdAt,
    this.updatedAt,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      categoryType: CategoryType.values.byName(json['categoryType'] as String),
      subItem: json['subItem'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'categoryType': categoryType.name,
      'subItem': subItem,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CalendarEvent copyWith({
    String? id,
    DateTime? date,
    CategoryType? categoryType,
    String? subItem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      date: date ?? this.date,
      categoryType: categoryType ?? this.categoryType,
      subItem: subItem ?? this.subItem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
