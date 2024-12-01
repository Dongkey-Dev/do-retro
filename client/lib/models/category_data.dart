import 'package:flutter/material.dart';
import 'package:simple_todo/l10n/app_localizations.dart';

enum CategoryType {
  daily,
  workStudy,
  important,
  personal,
}

class CategoryData {
  final CategoryType type;
  final Color color;
  final IconData icon;

  const CategoryData({
    required this.type,
    required this.color,
    required this.icon,
  });

  static final Map<String, Map<String, dynamic>> categories = {
    'daily': {
      'icon': Icons.home_rounded,
      'color': const Color(0xFF4CAF50),
      'subItems': ['아침 운동', '독서', '명상', '일기 쓰기'],
    },
    'workStudy': {
      'icon': Icons.work_rounded,
      'color': const Color(0xFF2196F3),
      'subItems': ['회의', '보고서', '프로젝트', '학습'],
    },
    'important': {
      'icon': Icons.priority_high_rounded,
      'color': const Color(0xFFF44336),
      'subItems': ['마감기한', '약속', '중요 미팅', '긴급 업무'],
    },
    'personal': {
      'icon': Icons.person_rounded,
      'color': const Color(0xFF9C27B0),
      'subItems': ['취미', '운동', '쇼핑', '자기계발'],
    },
  };

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case CategoryType.daily:
        return l10n.categoryDaily;
      case CategoryType.workStudy:
        return l10n.categoryWorkStudy;
      case CategoryType.important:
        return l10n.categoryImportant;
      case CategoryType.personal:
        return l10n.categoryPersonal;
    }
  }

  List<String> getSubItems(BuildContext context) {
    return categories[type.name]!['subItems'] ?? [];
  }
}

final List<CategoryData> defaultCategories = [
  const CategoryData(
    type: CategoryType.daily,
    color: Color(0xFF4CAF50),
    icon: Icons.home_rounded,
  ),
  const CategoryData(
    type: CategoryType.workStudy,
    color: Color(0xFF2196F3),
    icon: Icons.work_rounded,
  ),
  const CategoryData(
    type: CategoryType.important,
    color: Color(0xFFF44336),
    icon: Icons.priority_high_rounded,
  ),
  const CategoryData(
    type: CategoryType.personal,
    color: Color(0xFF9C27B0),
    icon: Icons.person_rounded,
  ),
];
