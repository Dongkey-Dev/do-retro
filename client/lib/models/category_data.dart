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

  // 카테고리의 하위 항목들을 현재 로케일에 맞게 반환
  List<String> getSubItems(BuildContext context) {
    final categoryKey = type.name;
    return CategoryData.getLocalizedSubItems(context, categoryKey);
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

  static List<String> getLocalizedSubItems(
      BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    final subItemKeys =
        categories[category]?['subItemKeys'] as List<String>? ?? [];

    return subItemKeys.map((key) {
      switch (key) {
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
          return key;
      }
    }).toList();
  }
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
