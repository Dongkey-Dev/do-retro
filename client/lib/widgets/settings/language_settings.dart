import 'package:flutter/material.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Localizations.localeOf(context),
      items: const [
        DropdownMenuItem(
          value: Locale('ko'),
          child: Text('한국어'),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          // SharedPreferences 등을 사용하여 선택된 언어 저장
          // MaterialApp의 locale을 업데이트
        }
      },
    );
  }
}
