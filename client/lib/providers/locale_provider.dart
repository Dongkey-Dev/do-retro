import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/strings.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _key = 'selected_locale';
  final SharedPreferences prefs;
  late Locale _locale;

  LocaleProvider({required this.prefs}) {
    // 저장된 언어 설정을 불러오거나 기본값 사용
    final savedLocale = prefs.getString(_key);
    _locale = savedLocale != null ? Locale(savedLocale) : const Locale('ko');
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  String translate(String key) {
    return Strings.translations[_locale.languageCode]?[key] ?? key;
  }
}
