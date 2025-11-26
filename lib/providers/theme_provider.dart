import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService storage;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(this.storage) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final saved = await storage.getThemeMode();
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggle() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await storage.saveThemeMode('light');
    } else {
      _themeMode = ThemeMode.dark;
      await storage.saveThemeMode('dark');
    }
    notifyListeners();
  }
}
