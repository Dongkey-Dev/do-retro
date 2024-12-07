import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/calendar_settings.dart';

class CalendarStartDaySettings extends StatelessWidget {
  const CalendarStartDaySettings({super.key});

  String _getStartDayName(BuildContext context, CalendarStartDay startDay) {
    final l10n = AppLocalizations.of(context)!;
    switch (startDay) {
      case CalendarStartDay.sunday:
        return l10n.sunday;
      case CalendarStartDay.monday:
        return l10n.monday;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(l10n.calendarStartDay),
      subtitle: Text(_getStartDayName(context, settingsProvider.startDay)),
      leading: const Icon(Icons.calendar_today),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.calendarStartDay),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<CalendarStartDay>(
                  title: Text(l10n.sunday),
                  value: CalendarStartDay.sunday,
                  groupValue: settingsProvider.startDay,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.saveStartDay(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<CalendarStartDay>(
                  title: Text(l10n.monday),
                  value: CalendarStartDay.monday,
                  groupValue: settingsProvider.startDay,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.saveStartDay(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
