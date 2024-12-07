import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:simple_todo/theme/app_theme.dart';
import '../../providers/calendar_provider.dart';
import '../../models/calendar_event.dart';
import '../../models/category_data.dart';
import '../../l10n/app_localizations.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onDaySelected;
  final DateTime selectedDate;
  static const int maxVisibleIcons = 5;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.onDaySelected,
    required this.selectedDate,
  });

  void _showSubItems(BuildContext context, CategoryData category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.getName(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: category.getSubItemsWithKeys(context).map((subItemData) {
            return ListTile(
              title: Text(subItemData.localizedText),
              onTap: () {
                Navigator.pop(context);
                _showTimePickerDialog(
                  context,
                  category,
                  subItemData,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    CategoryData category,
    SubItemData subItemData,
  ) {
    final l10n = AppLocalizations.of(context)!;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(subItemData.localizedText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.startTime),
                  trailing: Text(
                    startTime != null
                        ? '${startTime?.period == DayPeriod.am ? l10n.am : l10n.pm} ${startTime?.hourOfPeriod}:${startTime?.minute.toString().padLeft(2, '0')}'
                        : l10n.select,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              dialHandColor: category.color,
                              hourMinuteColor: category.color.withOpacity(0.1),
                              dayPeriodColor: category.color.withOpacity(0.1),
                              dayPeriodTextColor: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      setState(() {
                        startTime = time;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(l10n.endTime),
                  trailing: Text(
                    endTime != null
                        ? '${endTime?.period == DayPeriod.am ? l10n.am : l10n.pm} ${endTime?.hourOfPeriod}:${endTime?.minute.toString().padLeft(2, '0')}'
                        : l10n.select,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: endTime ?? TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              dialHandColor: category.color,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      setState(() {
                        endTime = time;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  final event = CalendarEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    date: date,
                    categoryType: category.type,
                    subItemKey: subItemData.key,
                    createdAt: DateTime.now(),
                    startTime: startTime,
                    endTime: endTime,
                  );

                  context.read<CalendarProvider>().addEvent(event);
                  Navigator.pop(context);
                },
                child: Text(l10n.confirm),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isTimeAfter(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final calendarTheme = Theme.of(context).calendarTheme;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    final calendarProvider = context.watch<CalendarProvider>();
    final events = calendarProvider.getEventsForDay(date);

    return PieMenu(
      theme: Theme.of(context).brightness == Brightness.dark
          ? const PieTheme(
              delayDuration: Duration(milliseconds: 200),
              brightness: Brightness.dark,
              overlayColor: Colors.black54,
            )
          : const PieTheme(
              delayDuration: Duration(milliseconds: 200),
              brightness: Brightness.light,
              overlayColor: Colors.white54,
            ),
      onPressed: () => onDaySelected(date),
      actions: defaultCategories
          .map(
            (category) => PieAction(
              tooltip: Text(category.getName(context)),
              child: CircleAvatar(
                backgroundColor: category.color,
                child: Icon(
                  category.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onSelect: () => _showSubItems(context, category),
            ),
          )
          .toList(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.08)
              : Colors.transparent,
          border: isToday
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2.5,
                )
              : isSelected
                  ? Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: date.weekday == DateTime.sunday
                        ? calendarTheme.sundayTextColor
                        : date.weekday == DateTime.saturday
                            ? Colors.blue
                            : calendarTheme.dayTextColor,
                    fontWeight: isToday || isSelected ? FontWeight.bold : null,
                    fontSize: isToday || isSelected ? 16 : 14,
                  ),
                ),
              ),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: [
                  ...events.take(maxVisibleIcons).map((event) {
                    final category = defaultCategories.firstWhere(
                      (c) => c.type == event.categoryType,
                      orElse: () => defaultCategories.first,
                    );
                    return Icon(
                      category.icon,
                      color: category.color,
                      size: 16,
                    );
                  }),
                  if (events.length > maxVisibleIcons)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${events.length - maxVisibleIcons}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
