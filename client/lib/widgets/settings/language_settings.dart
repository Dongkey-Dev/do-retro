import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(l10n.settingsLanguage),
      subtitle: Text(_getLanguageName(localeProvider.locale.languageCode)),
      leading: const Icon(Icons.language),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.settingsLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('한국어'),
                  value: 'ko',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(Locale(value));
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(Locale(value));
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
