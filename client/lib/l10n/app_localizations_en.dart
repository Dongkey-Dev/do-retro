import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get categoryDaily => 'Daily';

  @override
  String get categoryWorkStudy => 'Work/Study';

  @override
  String get categoryImportant => 'Important';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get dialogDeleteEventTitle => 'Delete Event';

  @override
  String get dialogDeleteEventContent => 'Are you sure you want to delete this event?';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogDelete => 'Delete';

  @override
  String get noEventsThisMonth => 'No events this month';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navStats => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System default';
}
