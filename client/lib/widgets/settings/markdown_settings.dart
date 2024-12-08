import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/providers/settings_provider.dart';

class MarkdownSettings extends StatelessWidget {
  const MarkdownSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

    return ListTile(
      title: Text(l10n.markdownSetting),
      subtitle: Text(l10n.markdownSettingDescription),
      leading: const Icon(Icons.text_fields),
      trailing: Switch(
        value: settingsProvider.useMarkdown,
        onChanged: (value) => settingsProvider.toggleMarkdown(value),
      ),
    );
  }
}
