import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// Daily category name
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get categoryDaily;

  /// Work/Study category name
  ///
  /// In en, this message translates to:
  /// **'Work/Study'**
  String get categoryWorkStudy;

  /// Important category name
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get categoryImportant;

  /// Personal category name
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// Title for delete event dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get dialogDeleteEventTitle;

  /// Content message for delete event dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event?'**
  String get dialogDeleteEventContent;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// Message shown when there are no events in the current month
  ///
  /// In en, this message translates to:
  /// **'No events this month'**
  String get noEventsThisMonth;

  /// Calendar tab label
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// Statistics tab label
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// Label for calendar navigation item
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Label for statistics navigation item
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Label for settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language settings title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @subItemMorningExercise.
  ///
  /// In en, this message translates to:
  /// **'Morning Exercise'**
  String get subItemMorningExercise;

  /// No description provided for @subItemReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get subItemReading;

  /// No description provided for @subItemMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get subItemMeditation;

  /// No description provided for @subItemDiary.
  ///
  /// In en, this message translates to:
  /// **'Write Diary'**
  String get subItemDiary;

  /// No description provided for @subItemMeeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get subItemMeeting;

  /// No description provided for @subItemReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get subItemReport;

  /// No description provided for @subItemProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get subItemProject;

  /// No description provided for @subItemStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get subItemStudy;

  /// No description provided for @subItemDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get subItemDeadline;

  /// No description provided for @subItemAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get subItemAppointment;

  /// No description provided for @subItemImportantMeeting.
  ///
  /// In en, this message translates to:
  /// **'Important Meeting'**
  String get subItemImportantMeeting;

  /// No description provided for @subItemUrgentTask.
  ///
  /// In en, this message translates to:
  /// **'Urgent Task'**
  String get subItemUrgentTask;

  /// No description provided for @subItemHobby.
  ///
  /// In en, this message translates to:
  /// **'Hobby'**
  String get subItemHobby;

  /// No description provided for @subItemExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get subItemExercise;

  /// No description provided for @subItemShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get subItemShopping;

  /// No description provided for @subItemSelfDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Self Development'**
  String get subItemSelfDevelopment;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get monthLabel;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **''**
  String get dayLabel;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectStartTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select start time first'**
  String get selectStartTimeFirst;

  /// No description provided for @endTimeMustBeAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeMustBeAfterStart;

  /// No description provided for @selectEndTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select end time'**
  String get selectEndTimeFirst;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get allDay;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @todoDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule description'**
  String get todoDescription;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get enterDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
