import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';
import '../../models/category_data.dart';
import '../../providers/calendar_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    final calendarProvider = context.watch<CalendarProvider>();
    final events = calendarProvider.getEventsForDay(date);

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
                    color: date.weekday == DateTime.sunday ? Colors.red : null,
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
                    final category = defaultCategories
                        .firstWhere((c) => c.type == event.categoryType);
                    return Icon(
                      category.icon,
                      color: category.color,
                      size: 16,
                    );
                  }),
                  if (events.length > maxVisibleIcons)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
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

  void _showSubItems(BuildContext context, CategoryData category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Icon(category.icon, color: category.color),
                const SizedBox(width: 12),
                Text(
                  category.getName(context),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: category.color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...category.getSubItems(context).map(
                  (subItem) => ListTile(
                    leading: Icon(category.icon,
                        color: category.color.withOpacity(0.5)),
                    title: Text(subItem),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      context.read<CalendarProvider>().addEvent(
                            date,
                            category.type,
                            subItem,
                          );
                      Navigator.pop(context);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
