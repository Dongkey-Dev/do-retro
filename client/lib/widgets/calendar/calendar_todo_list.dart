import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calendar_provider.dart';
import '../../models/calendar_event.dart';
import '../../models/category_data.dart';
import '../../l10n/app_localizations.dart';

class CalendarTodoList extends StatelessWidget {
  final DateTime currentMonth;

  const CalendarTodoList({
    super.key,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        final events = provider.getAllEventsForMonth(currentMonth);

        if (events.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(l10n.noEventsThisMonth),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Scrollbar(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 2),
              itemCount: events.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[100],
              ),
              itemBuilder: (context, index) {
                final event = events[index];
                final category = defaultCategories.firstWhere(
                  (c) => c.type == event.categoryType,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.color.withOpacity(0.2),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 20,
                    ),
                  ),
                  title: Text(event.subItem),
                  subtitle: Text(
                    '${event.date.month}월 ${event.date.day}일',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.dialogDeleteEventTitle),
                          content: Text(l10n.dialogDeleteEventContent),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.dialogCancel),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.deleteEvent(event.id);
                                Navigator.pop(context);
                              },
                              child: Text(
                                l10n.dialogDelete,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
