import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/history_provider.dart';
import 'services/storage_service.dart';
import 'utils/expression_parser.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  final parser = ExpressionParser();
  runApp(AdvancedCalculatorApp(storage: storage, parser: parser));
}

class AdvancedCalculatorApp extends StatelessWidget {
  final StorageService storage;
  final ExpressionParser parser;
  const AdvancedCalculatorApp({
    Key? key,
    required this.storage,
    required this.parser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(storage)),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(storage: storage),
        ),
        ChangeNotifierProvider(
          create: (_) => CalculatorProvider(storage: storage, parser: parser),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          final lightTheme = ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: AppColors.accentColor,
              secondary: AppColors.secondaryDark,
              surface: AppColors.surfaceLight,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: AppColors.textDark,
            ),
            scaffoldBackgroundColor: AppColors.backgroundLight,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              elevation: 2,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          );

          final darkTheme = ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentBright,
              secondary: AppColors.secondaryLight,
              surface: AppColors.surfaceDark,
              onPrimary: AppColors.primaryDark,
              onSecondary: AppColors.primaryDark,
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: AppColors.backgroundDark,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryDarkest,
              foregroundColor: Colors.white,
              elevation: 2,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          );

          return MaterialApp(
            title: AppText.appTitleVi,
            debugShowCheckedModeBanner: false,
            themeMode: themeProv.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            initialRoute: '/',
            routes: {
              '/': (_) => CalculatorScreen(),
              '/history': (_) => HistoryScreen(),
              '/settings': (_) => SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
