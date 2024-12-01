import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _key = 'theme_mode';
  final SharedPreferences prefs;
  ThemeMode _themeMode;

  ThemeProvider({required this.prefs})
      : _themeMode =
            ThemeMode.values[prefs.getInt(_key) ?? ThemeMode.system.index];

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    prefs.setInt(_key, mode.index);
    notifyListeners();
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
