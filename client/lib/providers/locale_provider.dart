import 'package:flutter/material.dart';

import '../l10n/strings.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ko'); // 기본값 한국어

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  String translate(String key) {
    return Strings.translations[_locale.languageCode]?[key] ?? key;
  }
}
