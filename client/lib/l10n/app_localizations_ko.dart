import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get categoryDaily => '일상';

  @override
  String get categoryWorkStudy => '업무/학업';

  @override
  String get categoryImportant => '중요';

  @override
  String get categoryPersonal => '개인';

  @override
  String get dialogDeleteEventTitle => '일정 삭제';

  @override
  String get dialogDeleteEventContent => '이 일정을 삭제하시겠습니까?';

  @override
  String get dialogCancel => '취소';

  @override
  String get dialogDelete => '삭제';

  @override
  String get noEventsThisMonth => '이번 달 일정이 없습니다';
}
