import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import '../widgets/calendar/calendar_view.dart';
import '../l10n/app_localizations.dart';
import '../screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // screens를 build 메서드 안에서 생성
    final screens = [
      CalendarView(
        selectedDate: _selectedDate,
        onDaySelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
      const Center(child: Text('통계')),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex], // _screens 대신 screens 사용
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_today),
            label: l10n.calendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
