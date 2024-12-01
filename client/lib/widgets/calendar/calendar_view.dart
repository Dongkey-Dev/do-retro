import 'package:flutter/material.dart';
import 'calendar_header.dart';
import 'month_view.dart';
import 'calendar_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'week_view.dart';
import 'package:flutter/gestures.dart';
import 'calendar_todo_list.dart';

enum CalendarViewType {
  month,
  week,
}

class CalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;

  const CalendarView({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with SingleTickerProviderStateMixin {
  CalendarViewType _viewType = CalendarViewType.month;
  late AnimationController _animationController;
  late Animation<double> _heightFactor;
  late CalendarController _calendarController;
  bool _isTwoFingerGesture = false;
  double _lastScale = 1.0;
  static const double _zoomInThreshold = 1.2;
  static const double _zoomOutThreshold = 0.85;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController(widget.selectedDate);
    _initializeAnimation();
    _calendarController.preloadMonths(1000);
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _isTwoFingerGesture = details.pointerCount >= 2;
    _lastScale = 1.0;
    print('Scale Start - Pointers: ${details.pointerCount}');
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_isTwoFingerGesture) return;

    final double scaleDiff = details.scale - _lastScale;
    _lastScale = details.scale;

    print(
        'Scale: ${details.scale}, Diff: $scaleDiff, Pointers: ${details.pointerCount}');

    if (_viewType == CalendarViewType.month &&
        details.scale > _zoomInThreshold) {
      setState(() {
        _viewType = CalendarViewType.week;
        _animationController.forward();
      });
    } else if (_viewType == CalendarViewType.week &&
        (details.scale < _zoomOutThreshold || scaleDiff < -0.15)) {
      setState(() {
        _viewType = CalendarViewType.month;
        _animationController.reverse();
      });
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (!_isTwoFingerGesture) return;

    if (details.velocity.pixelsPerSecond.distance > 150 &&
        _viewType == CalendarViewType.week) {
      setState(() {
        _viewType = CalendarViewType.month;
        _animationController.reverse();
      });
    }

    _isTwoFingerGesture = false;
    _lastScale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RawGestureDetector(
          gestures: {
            ScaleGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
              () => ScaleGestureRecognizer()
                ..dragStartBehavior = DragStartBehavior.down
                ..onStart = _handleScaleStart
                ..onUpdate = _handleScaleUpdate
                ..onEnd = _handleScaleEnd,
              (instance) {},
            ),
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              CalendarHeader(
                currentMonth: _calendarController.currentMonth,
                viewType: _viewType,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _calendarController.pageController,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (context, index) => _buildCalendarView(index),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CalendarTodoList(
                  currentMonth: _calendarController.currentMonth,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.list_alt),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Todo 모아보기',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              // Todo 리스트 모달 또는 페이지로 이동
              print('Todo 모아보기');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.settings),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: '설정',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              // 설정 페이지로 이동
              print('설정');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.analytics),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: '통계',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              // 통계 페이지로 이동
              print('통계');
            },
          ),
        ],
      ),
    );
  }

  void _handlePageChanged(int page) {
    _calendarController.preloadMonths(page);
    final newDate = _calendarController.getMonthForPage(page);
    setState(() {
      _calendarController.currentMonth = newDate;
    });
  }

  Widget _buildCalendarView(int index) {
    final monthDate = _calendarController.getMonthForPage(index);

    switch (_viewType) {
      case CalendarViewType.month:
        return MonthView(
          monthDate: monthDate,
          selectedDate: widget.selectedDate,
          heightFactor: _heightFactor,
          onDaySelected: widget.onDaySelected,
        );

      case CalendarViewType.week:
        return WeekView(
          selectedDate: widget.selectedDate,
          onDaySelected: widget.onDaySelected,
          heightFactor: _heightFactor,
        );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
}
