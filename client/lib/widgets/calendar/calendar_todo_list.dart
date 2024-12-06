import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calendar_provider.dart';
import '../../models/category_data.dart';
import '../../l10n/app_localizations.dart';

class CalendarTodoList extends StatefulWidget {
  final DateTime currentMonth;

  const CalendarTodoList({
    super.key,
    required this.currentMonth,
  });

  @override
  State<CalendarTodoList> createState() => _CalendarTodoListState();
}

class _CalendarTodoListState extends State<CalendarTodoList> {
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 이벤트 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarProvider>().loadEvents(widget.currentMonth);
    });
  }

  @override
  void didUpdateWidget(CalendarTodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 월이 변경될 때마다 새로운 이벤트 로드
    if (oldWidget.currentMonth != widget.currentMonth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CalendarProvider>().loadEvents(widget.currentMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CalendarProvider>();
    final l10n = AppLocalizations.of(context)!;
    final events = provider.getAllEventsForMonth(widget.currentMonth);

    // 로딩 상태 처리
    if (provider.isLoading) {
      return Center(
        child: Text(l10n.noEventsThisMonth),
      );
    }

    if (events.isEmpty) {
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
        child: Center(
          child: Text(
            l10n.noEventsThisMonth,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
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
            color: theme.brightness == Brightness.dark
                ? Colors.grey[800] // 다크모드일 때
                : Colors.grey[200], // 라이트모드일 때
          ),
          itemBuilder: (context, index) {
            final event = events[index];
            final category = defaultCategories.firstWhere(
              (c) => c.type == event.categoryType,
            );
            final l10n = AppLocalizations.of(context)!;

            // 시간 정보 포맷팅
            String timeInfo = '';
            if (event.startTime == null && event.endTime == null) {
              timeInfo = ' ${l10n.allDay}'; // '종일'
            } else if (event.startTime == null) {
              final endPeriod =
                  event.endTime!.period == DayPeriod.am ? l10n.am : l10n.pm;
              timeInfo =
                  ' ${l10n.allDay} - ${endPeriod} ${event.endTime!.hourOfPeriod}:${event.endTime!.minute.toString().padLeft(2, '0')}';
            } else if (event.endTime == null) {
              final startPeriod =
                  event.startTime!.period == DayPeriod.am ? l10n.am : l10n.pm;
              timeInfo =
                  ' ${startPeriod} ${event.startTime!.hourOfPeriod}:${event.startTime!.minute.toString().padLeft(2, '0')} - ${l10n.allDay}';
            } else {
              final startPeriod =
                  event.startTime!.period == DayPeriod.am ? l10n.am : l10n.pm;
              final endPeriod =
                  event.endTime!.period == DayPeriod.am ? l10n.am : l10n.pm;
              timeInfo =
                  ' ${startPeriod} ${event.startTime!.hourOfPeriod}:${event.startTime!.minute.toString().padLeft(2, '0')} - '
                  '${endPeriod} ${event.endTime!.hourOfPeriod}:${event.endTime!.minute.toString().padLeft(2, '0')}';
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color.withOpacity(0.2),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 20,
                ),
              ),
              title: Text(event.getLocalizedSubItem(context)),
              subtitle: Text(
                '${event.date.month}${l10n.monthLabel} ${event.date.day}${l10n.dayLabel}$timeInfo',
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
                          child: Text(l10n.cancel),
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
  }
}
