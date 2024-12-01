import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import '../widgets/calendar/calendar_view.dart';
import '../l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late DateTime _selectedDate = DateTime.now();

  // 각 탭에 해당하는 화면들
  late final List<Widget> _screens = [
    CalendarView(
      selectedDate: _selectedDate,
      onDaySelected: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    ),
    const Center(child: Text('통계')), // 추후 통계 화면으로 교체
    const Center(child: Text('설정')), // 추후 설정 화면으로 교체
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PieCanvas(
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today),
                label: l10n.navCalendar,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: l10n.navStats,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: l10n.navSettings,
              ),
            ],
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
