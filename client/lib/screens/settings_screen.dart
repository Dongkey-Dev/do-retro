import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/widgets/settings/calendar_start_day_settings.dart';
import '../providers/theme_provider.dart';
import '../widgets/settings/language_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.settingsTheme),
            subtitle: Text(_getThemeModeName(context, themeProvider.themeMode)),
            leading: const Icon(Icons.palette_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, themeProvider),
          ),
          const LanguageSettings(),
          const CalendarStartDaySettings(),
        ],
      ),
    );
  }

  String _getThemeModeName(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values
              .map(
                (mode) => RadioListTile<ThemeMode>(
                  title: Text(_getThemeModeName(context, mode)),
                  value: mode,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
