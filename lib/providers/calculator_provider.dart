import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/expression_parser.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';

class CalculatorProvider extends ChangeNotifier {
  final StorageService storage;
  final ExpressionParser parser;

  String expression = '';
  String previousResult = '';
  String? errorMessage;
  double memory = 0.0;
  CalculatorMode mode = CalculatorMode.basic;
  String angleMode = 'DEG';
  double displayFontSize = 36;
  int decimalPrecision = 6;
  bool hapticEnabled = true;
  int historySize = 50;
  String currentNumberBase = 'DEC';

  bool _justEvaluated = false;

  CalculatorProvider({
    required this.storage,
    required this.parser,
    bool autoInit = true,
  }) {
    if (autoInit) _initialize();
  }

  Future<void> _initialize() async {
    final mem = await storage.getMemory();
    memory = mem ?? 0.0;
    final savedMode = await storage.getMode();
    if (savedMode != null) mode = savedMode;
    final ang = await storage.getAngleMode();
    if (ang != null) angleMode = ang;
    notifyListeners();
  }

  void appendToExpression(String value) {
    errorMessage = null;

    if (_justEvaluated) {
      final isOperatorStart =
          value.startsWith('+') ||
          value.startsWith('-') ||
          value.startsWith('*') ||
          value.startsWith('/');

      if (isOperatorStart && previousResult.isNotEmpty) {
        expression = previousResult + value;
      } else {
        expression = '';
        previousResult = '';
        expression += value;
      }
      _justEvaluated = false;
    } else {
      expression += value;
    }

    notifyListeners();
  }

  void setExpressionValue(String value) {
    expression = value;
    _justEvaluated = false;
    notifyListeners();
  }

  void removeLastCharacter() {
    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
      _justEvaluated = false;
      notifyListeners();
    }
  }

  void clearCalculation() {
    expression = '';
    previousResult = '';
    errorMessage = null;
    _justEvaluated = false;
    notifyListeners();
  }

  void toggleSignOfExpression() {
    if (expression.isEmpty) return;
    final current = double.tryParse(expression);
    if (current != null) {
      expression = (current * -1).toString();
    } else if (expression.startsWith('-')) {
      expression = expression.substring(1);
    } else {
      expression = '-$expression';
    }
    _justEvaluated = false;
    notifyListeners();
  }

  Future<void> evaluateExpression() async {
    if (expression.trim().isEmpty) return;

    if (currentNumberBase == 'HEX' && expression.contains('AND')) {
      final originalExpression = expression;
      final parts = expression.split('AND');

      if (parts.length == 2) {
        try {
          final left = _parseFromBase(parts[0].trim(), currentNumberBase);
          final right = _parseFromBase(parts[1].trim(), currentNumberBase);

          final result = left & right;
          final output = _convertToBase(result, currentNumberBase);

          previousResult = output;
          expression = output;
          errorMessage = null;
          _justEvaluated = true;

          await storage.saveHistoryItem(
            CalculationHistory(
              expression: originalExpression,
              result: output,
              timestamp: DateTime.now(),
            ),
            maxItems: historySize,
          );

          notifyListeners();
          return;
        } catch (e) {
          errorMessage = 'Lỗi bitwise: $e';
          _justEvaluated = false;
          notifyListeners();
          return;
        }
      }
    }

    try {
      final originalExpression = expression;

      final value = parser.evaluate(
        expression,
        angleMode: degrees ? 'DEG' : 'RAD',
      );
      final formatted = _formatNumber(value);

      previousResult = formatted;
      expression = formatted;

      await storage.saveHistoryItem(
        CalculationHistory(
          expression: originalExpression,
          result: formatted,
          timestamp: DateTime.now(),
        ),
        maxItems: historySize,
      );

      errorMessage = null;
      _justEvaluated = true;
    } catch (e) {
      errorMessage = e.toString();
      _justEvaluated = false;
    }
    notifyListeners();
  }

  String _formatNumber(double value) {
    return value
        .toStringAsFixed(decimalPrecision)
        .replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void memoryPlus() {
    final current =
        double.tryParse(previousResult) ?? double.tryParse(expression) ?? 0.0;
    memory += current;
    storage.saveMemory(memory);
    notifyListeners();
  }

  void memoryMinus() {
    final current =
        double.tryParse(previousResult) ?? double.tryParse(expression) ?? 0.0;
    memory -= current;
    storage.saveMemory(memory);
    notifyListeners();
  }

  void memoryRecall() {
    if (_justEvaluated) {
      expression = '';
      previousResult = '';
      _justEvaluated = false;
    }
    expression += _formatNumber(memory);
    notifyListeners();
  }

  void memoryClear() {
    memory = 0.0;
    storage.saveMemory(memory);
    notifyListeners();
  }

  void switchCalculatorMode(CalculatorMode newMode) {
    mode = newMode;
    storage.saveMode(newMode);
    _justEvaluated = false;
    notifyListeners();
  }

  void updateAngleMode(String newAngleMode) {
    angleMode = newAngleMode;
    storage.saveAngleMode(newAngleMode);
    notifyListeners();
  }

  void updateDecimalPrecision(int precision) {
    decimalPrecision = precision;
    notifyListeners();
  }

  void adjustDisplayFontSize(double newSize) {
    displayFontSize = newSize.clamp(14.0, 56.0);
    notifyListeners();
  }

  Future<void> clearAllHistoryWithConfirm() async {
    await storage.clearHistory();
    notifyListeners();
  }

  void setNumberBase(String base) {
    currentNumberBase = base;
    _justEvaluated = false;
    notifyListeners();
  }

  void processNumberBaseConversion(String label) {
    if (expression.isEmpty) {
      expression = '0';
    }

    try {
      final currentValue = _parseFromBase(expression, currentNumberBase);
      currentNumberBase = label;
      expression = _convertToBase(currentValue, label);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Lỗi chuyển đổi: $e';
    }
    _justEvaluated = false;
    notifyListeners();
  }

  void processBitwiseOperation(String operation) {
    if (expression.isEmpty) return;

    try {
      final currentValue = _parseFromBase(expression, currentNumberBase);
      int result;

      switch (operation) {
        case 'NOT':
          result = ~currentValue.toInt();
          expression = _convertToBase(result, currentNumberBase);
          errorMessage = null;
          break;
        default:
          expression += operation;
      }
    } catch (e) {
      errorMessage = 'Lỗi phép toán: $e';
    }
    _justEvaluated = false;
    notifyListeners();
  }

  void processBitwiseExpression(String operation) {
    if (expression.isNotEmpty && !RegExp(r'(\s)$').hasMatch(expression)) {
      expression += ' $operation ';
      errorMessage = null;
      _justEvaluated = false;
      notifyListeners();
    }
  }

  int _parseFromBase(String value, String base) {
    final cleanValue = value.trim();
    switch (base) {
      case 'BIN':
        return int.parse(cleanValue, radix: 2);
      case 'OCT':
        return int.parse(cleanValue, radix: 8);
      case 'HEX':
        return int.parse(cleanValue, radix: 16);
      case 'DEC':
      default:
        return int.parse(cleanValue);
    }
  }

  String _convertToBase(int value, String base) {
    switch (base) {
      case 'BIN':
        return value.toRadixString(2);
      case 'OCT':
        return value.toRadixString(8);
      case 'HEX':
        return value.toRadixString(16).toUpperCase();
      case 'DEC':
      default:
        return value.toString();
    }
  }

  bool get isProgrammerMode => mode == CalculatorMode.programmer;
  bool get hasMemoryValue => memory != 0.0;
  bool get hasError => errorMessage != null;
  bool get degrees => angleMode == 'DEG';

  Future<void> setDegrees(bool value) async {
    angleMode = value ? 'DEG' : 'RAD';
    await storage.saveAngleMode(angleMode);
    notifyListeners();
  }
}
