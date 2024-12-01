import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/l10n/app_localizations.dart';
import 'package:simple_todo/repositories/local_calendar_repository.dart';
import 'package:simple_todo/repositories/remote_calendar_repository.dart';
import 'screens/calendar_screen.dart';
import 'providers/locale_provider.dart';
import 'services/calendar_service.dart';
import 'providers/calendar_provider.dart';
import 'repositories/persistent_repository_decorator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localRepository = LocalCalendarRepository(prefs: prefs);

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
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(service: service),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: PieCanvas(
            theme: const PieTheme(
              overlayColor: Colors.black26,
              pointerColor: Colors.white,
              buttonTheme: PieButtonTheme(
                backgroundColor: Colors.white,
                iconColor: Colors.black,
              ),
              buttonSize: 64,
              radius: 100,
              tooltipTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ko'), // 한국어
                Locale('en'), // 영어
              ],
              locale: localeProvider.locale,
              title: 'Calendar Todo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const CalendarScreen(),
            ),
          ),
        );
      },
    );
  }
}