import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E1E);
  static const Color secondaryDark = Color(0xFF424242);
  static const Color accentColor = Color(0xFFFF6B6B);

  static const Color primaryDarkest = Color(0xFF121212);
  static const Color secondaryLight = Color(0xFF2C2C2C);
  static const Color accentBright = Color(0xFF4ECDC4);

  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  static const Color warningColor = Color(0xFFFB8C00);
  static const Color dividerColor = Color(0xFFBDBDBD);
}

class AppDimens {
  static const double buttonSpacing = 12.0;
  static const double buttonRadius = 16.0;
  static const double displayRadius = 24.0;
  static const double screenPadding = 24.0;
  static const double buttonPaddingVertical = 16.0;
  static const double buttonPaddingHorizontal = 12.0;

  static const Duration buttonPressDuration = Duration(milliseconds: 200);
  static const Duration modeSwitchDuration = Duration(milliseconds: 300);
  static const Duration errorShakeDuration = Duration(milliseconds: 350);
  static const Duration resultFadeInDuration = Duration(milliseconds: 250);
}

class ButtonLabels {
  static const List<List<String>> basicGrid = [
    ['C', 'CE', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['±', '0', '.', '='],
  ];

  static const List<List<String>> scientificGrid = [
    ['2nd', 'sin', 'cos', 'tan', 'Ln', 'log'],
    ['x²', '√', 'x^y', '(', ')', '÷'],
    ['MC', '7', '8', '9', 'C', '×'],
    ['MR', '4', '5', '6', 'CE', '-'],
    ['M+', '1', '2', '3', '%', '+'],
    ['M-', '±', '0', '.', 'π', '='],
  ];

  static const programmerGrid = [
    ['A', 'B', 'C', 'D'],
    ['E', 'F', '0', '1'],
    ['2', '3', '4', '5'],
    ['6', '7', '8', '9'],
    ['AND', 'OR', 'XOR', 'NOT'],
    ['<<', '>>', 'CE', 'C', '='],
  ];
}

class AppText {
  static const String appTitle = "Advanced Calculator";
  static const String appTitleVi = "Máy Tính Nâng Cao";

  static const String basicMode = "Basic";
  static const String scientificMode = "Scientific";
  static const String programmerMode = "Programmer";

  static const String degMode = "DEG";
  static const String radMode = "RAD";

  static const String historyScreenTitle = "Lịch Sử Tính Toán";
  static const String settingsScreenTitle = "Cài Đặt";
  static const String noHistoryMessage = "Chưa có lịch sử";
}

class AppAnimations {
  static const Duration errorShakeDuration = Duration(milliseconds: 350);
  static const Duration buttonScalePressDuration = Duration(milliseconds: 150);
  static const Duration modeSwitchAnimDuration = Duration(milliseconds: 300);
}

class AppConst {
  static const int defaultHistorySize = 50;
  static const int minDecimalPlaces = 2;
  static const int maxDecimalPlaces = 10;
  static const double minDisplayFontSize = 14.0;
  static const double maxDisplayFontSize = 56.0;
  static const double defaultDisplayFontSize = 36.0;
}
