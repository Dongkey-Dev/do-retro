import 'package:flutter/material.dart';
import 'package:simple_todo/l10n/app_localizations.dart';

enum CategoryType {
  daily,
  workStudy,
  important,
  personal,
}

class SubItemData {
  final String key;
  final String localizedText;

  SubItemData(this.key, this.localizedText);
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

  // 카테고리 이름을 현재 로케일에 맞게 반환
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

  // 카테고리의 하위 항목들을 현와 현지화된 텍스트 쌍으로 반환
  List<SubItemData> getSubItemsWithKeys(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryKey = type.name;
    final subItemKeys =
        categories[categoryKey]?['subItemKeys'] as List<String>? ?? [];

    return subItemKeys.map((key) {
      String localizedText = switch (key) {
        'subItemMorningExercise' => l10n.subItemMorningExercise,
        'subItemReading' => l10n.subItemReading,
        'subItemMeditation' => l10n.subItemMeditation,
        'subItemDiary' => l10n.subItemDiary,
        'subItemMeeting' => l10n.subItemMeeting,
        'subItemReport' => l10n.subItemReport,
        'subItemProject' => l10n.subItemProject,
        'subItemStudy' => l10n.subItemStudy,
        'subItemDeadline' => l10n.subItemDeadline,
        'subItemAppointment' => l10n.subItemAppointment,
        'subItemImportantMeeting' => l10n.subItemImportantMeeting,
        'subItemUrgentTask' => l10n.subItemUrgentTask,
        'subItemHobby' => l10n.subItemHobby,
        'subItemExercise' => l10n.subItemExercise,
        'subItemShopping' => l10n.subItemShopping,
        'subItemSelfDevelopment' => l10n.subItemSelfDevelopment,
        _ => key
      };
      return SubItemData(key, localizedText);
    }).toList();
  }

  static final Map<String, Map<String, dynamic>> categories = {
    'daily': {
      'icon': Icons.home_rounded,
      'color': const Color(0xFF4CAF50),
      'subItemKeys': [
        'subItemMorningExercise',
        'subItemReading',
        'subItemMeditation',
        'subItemDiary',
      ],
    },
    'workStudy': {
      'icon': Icons.work_rounded,
      'color': const Color(0xFF2196F3),
      'subItemKeys': [
        'subItemMeeting',
        'subItemReport',
        'subItemProject',
        'subItemStudy',
      ],
    },
    'important': {
      'icon': Icons.priority_high_rounded,
      'color': const Color(0xFFF44336),
      'subItemKeys': [
        'subItemDeadline',
        'subItemAppointment',
        'subItemImportantMeeting',
        'subItemUrgentTask',
      ],
    },
    'personal': {
      'icon': Icons.person_rounded,
      'color': const Color(0xFF9C27B0),
      'subItemKeys': [
        'subItemHobby',
        'subItemExercise',
        'subItemShopping',
        'subItemSelfDevelopment',
      ],
    },
  };
}

final List<CategoryData> defaultCategories = [
  CategoryData(
    type: CategoryType.daily,
    icon: CategoryData.categories['daily']!['icon'] as IconData,
    color: CategoryData.categories['daily']!['color'] as Color,
  ),
  CategoryData(
    type: CategoryType.workStudy,
    icon: CategoryData.categories['workStudy']!['icon'] as IconData,
    color: CategoryData.categories['workStudy']!['color'] as Color,
  ),
  CategoryData(
    type: CategoryType.important,
    icon: CategoryData.categories['important']!['icon'] as IconData,
    color: CategoryData.categories['important']!['color'] as Color,
  ),
  CategoryData(
    type: CategoryType.personal,
    icon: CategoryData.categories['personal']!['icon'] as IconData,
    color: CategoryData.categories['personal']!['color'] as Color,
  ),
];
