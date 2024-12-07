import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:simple_todo/providers/calendar_provider.dart';
import 'calendar_header.dart';
import 'month_view.dart';
import 'calendar_todo_list.dart';
import 'package:provider/provider.dart';

enum CalendarViewType {
  month,
  week,
}

class CalendarView extends StatefulWidget {
  final DateTime todayDate;
  final Function(DateTime) onDaySelected;

  const CalendarView({
    super.key,
    required this.todayDate,
    required this.onDaySelected,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late PageController _pageController;
  late DateTime _currentMonth;
  final Map<int, DateTime> _monthCache = {}; // 페이지 인덱스별 월 데이터 캐시

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.todayDate.year, widget.todayDate.month);
    _pageController = PageController(initialPage: 1000);

    // 초기 3개월 캐시 설정
    _monthCache[999] =
        DateTime(_currentMonth.year, _currentMonth.month - 1); // 이전 달
    _monthCache[1000] = _currentMonth; // 현재 달
    _monthCache[1001] =
        DateTime(_currentMonth.year, _currentMonth.month + 1); // 다음 달

    // 초기 데이터 즉시 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final calendarProvider = context.read<CalendarProvider>();
      calendarProvider.preloadMonths([
        _monthCache[999]!,
        _monthCache[1000]!,
        _monthCache[1001]!,
      ]);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMonthChanged(int page) {
    // 캐시된 월 데이터 사용
    final newMonth = _monthCache[page] ??
        DateTime(
          _currentMonth.year,
          _currentMonth.month + (page - 1000),
        );

    setState(() {
      _currentMonth = newMonth;
    });

    // 캐시 업데이트
    _updateMonthCache(page);

    // 월이 변경될 때는 날짜 선택을 하지 않도록 수정
    // widget.onDaySelected(DateTime(newMonth.year, newMonth.month, 1));
  }

  void _updateMonthCache(int currentPage) {
    // 현재 페이지 기준으로 이전/다음 페이지 캐시 업데이트
    _monthCache[currentPage - 1] = DateTime(
      _currentMonth.year,
      _currentMonth.month - 1,
    );
    _monthCache[currentPage] = _currentMonth;
    _monthCache[currentPage + 1] = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
    );

    // 새로운 달의 데이터 즉시 로드
    final calendarProvider = context.read<CalendarProvider>();
    calendarProvider.preloadMonths([
      _monthCache[currentPage - 1]!,
      _monthCache[currentPage]!,
      _monthCache[currentPage + 1]!,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return PieCanvas(
      theme: const PieTheme(
        overlayColor: Colors.black54,
        pointerSize: 0,
      ),
      child: SafeArea(
        child: Column(
          children: [
            CalendarHeader(
              viewType: CalendarViewType.month,
              currentMonth: _currentMonth,
              onPreviousMonth: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              onNextMonth: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              onTitleTapped: () {},
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onMonthChanged,
                      itemBuilder: (context, index) {
                        final itemMonth = _monthCache[index] ??
                            DateTime(
                              _currentMonth.year,
                              _currentMonth.month + (index - 1000),
                            );
                        return MonthView(
                          monthDate: itemMonth,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CalendarTodoList(
                      currentMonth: _currentMonth,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
