import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/repositories/local_calendar_repository.dart';
import 'package:simple_todo/repositories/remote_calendar_repository.dart';
import 'screens/main_screen.dart';
import 'providers/locale_provider.dart';
import 'services/calendar_service.dart';
import 'providers/calendar_provider.dart';
import 'repositories/persistent_repository_decorator.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localeProvider = LocaleProvider(prefs: prefs);
  final localRepository = LocalCalendarRepository(prefs: prefs);
  final themeProvider = ThemeProvider(prefs: prefs);

  // 환경에 따라 적절한 repository 선택
  final bool useRemote = false; // 개발 중에는 로컬 저장소 사용

  final baseRepository = useRemote
      ? RemoteCalendarRepository(baseUrl: 'https://api.example.com/v1')
      : localRepository;

  // Decorator로 감싸기
  final repository = PersistentRepositoryDecorator(
    remote: baseRepository,
    local: localRepository,
  );

  final service = CalendarService(repository: repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(service: service),
        ),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      locale: localeProvider.locale,
      title: 'Calendar Todo',
      themeMode: themeProvider.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: MainScreen(),
    );
  }
}
