import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_menu/pie_menu.dart';
import '../../providers/calendar_provider.dart';
import '../../models/calendar_event.dart';
import '../../models/category_data.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;
  static const int maxVisibleIcons = 5;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.selectedDate,
    required this.onDaySelected,
  });

  void _showSubItems(BuildContext context, CategoryData category) {
    final calendarProvider = context.read<CalendarProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.getName(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: category.getSubItems(context).map((subItem) {
            return ListTile(
              title: Text(subItem),
              onTap: () {
                final event = CalendarEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: date,
                  categoryType: category.type,
                  subItem: subItem,
                  createdAt: DateTime.now(),
                );

                calendarProvider.addEvent(
                    event.date, event.categoryType, event.subItem);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    final calendarProvider = context.watch<CalendarProvider>();
    final events = calendarProvider.getEventsForDay(date) ?? [];

    return PieMenu(
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
      child: GestureDetector(
        onTap: () => onDaySelected(date),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color:
                          date.weekday == DateTime.sunday ? Colors.red : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
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
      ),
    );
  }
}
