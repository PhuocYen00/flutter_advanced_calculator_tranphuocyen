🧪 TESTING.md

Advanced Calculator – Flutter Application
Author: Tran Phuoc Yen
Student ID: 2224802010093

1. Overview

This document describes the testing strategy, methodology, tools, and test cases implemented for the Advanced Calculator Flutter Application.

Testing ensures:

Reliability of calculator operations

Correctness of scientific and programmer functions

Stability of state management

Accuracy of expression parsing

Proper functionality of persistent storage

All tests are implemented using Flutter's built-in test framework and are located in:

/test/flutter_test.dart

2. Testing Methodology

The project uses three primary testing approaches:

✅ 2.1 Unit Testing

Unit tests focus on:

ExpressionParser logic

CalculatorProvider core operations

Memory functions

Angle mode switching

Programmer mode bitwise operations

Base conversion logic

Unit tests run independently of UI and storage by mocking persistence.

✅ 2.2 Integration Testing (Partial)

Integration testing ensures that:

Provider logic works with ExpressionParser

StorageService interactions (mocked) work correctly

Chain operations behave consistently

❌ 2.3 No Widget/UI Tests (Reason)

This project intentionally excludes UI tests because:

UI involves only presentation

All business logic is fully isolated inside Providers

UI state is entirely reactive through Provider

This keeps the test suite clean and focused.

3. Tools & Environment

Flutter SDK 3.x+

Dart test framework (flutter_test)

Mocked StorageService (FakeStorage)

Provider for state management

Run all tests using:

flutter test

4. Mocking Strategy

The app normally uses SharedPreferences for:

Memory (M+, MR)

Calculator mode

Angle mode

History persistence

However, SharedPreferences cannot run in unit tests.

Therefore, a full mock class was implemented:

class FakeStorage extends StorageService {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> saveAngleMode(String mode) async => _data['angleMode'] = mode;

  @override
  Future<String?> getAngleMode() async => _data['angleMode'];

  @override
  Future<void> saveMemory(double value) async => _data['memory'] = value;

  @override
  Future<double?> getMemory() async => _data['memory'];

  @override
  Future<void> saveMode(CalculatorMode mode) async => _data['mode'] = mode;

  @override
  Future<CalculatorMode?> getMode() async => _data['mode'];

  @override
  Future<void> saveHistoryItem(CalculationHistory item, {int maxItems = 50}) async {
    _data.putIfAbsent("history", () => <CalculationHistory>[]);
    final list = _data["history"] as List<CalculationHistory>;

    list.add(item);
    if (list.length > maxItems) list.removeAt(0);
  }

  @override
  Future<List<CalculationHistory>> getHistory() async =>
      List<CalculationHistory>.from(_data["history"] ?? []);
}


This allows testing the entire calculator without SharedPreferences.

5. Test Coverage

Below is a detailed list of all test scenarios implemented.

6. Test Cases
🧮 6.1 Complex Arithmetic Expressions
Test
(5+3) × 2 − 4 ÷ 2 = 14

Purpose

Verifies correct operator precedence:

Parentheses

Multiplication/Division

Addition/Subtraction

🔢 6.2 Chain Calculations
Test
5 + 3 = +2 = +1 = 11

Purpose

Ensures _justEvaluated flag works properly:

Result becomes new base expression

Chaining continues correctly

📐 6.3 Scientific Functions
Case A: sin(45) + cos(45) ≈ 1.414

Tests:

Angle mode = DEG

Trigonometric accuracy

Multiple function evaluation

🔍 6.4 Nested Parentheses
Test
((2 + 3) * (4 - 1)) / 5 = 3

Purpose

Deep expression parsing

Parentheses handling

Order of evaluation

🧬 6.5 Mixed Scientific Computation
Test
2 × π × √9 ≈ 18.85

Purpose

Constant replacement (pi)

Function (sqrt)

Mixed operations

💾 6.6 Memory Operations (M+, MR)
Test
5 M+  → memory = 5
3 M+  → memory = 8
MR    → recall value = 8

Purpose

Memory addition

Persistent memory value

Correct recall insertion

🖥️ 6.7 Programmer Mode Logic
Test
HEX: FF AND 0F → 0F  (or simply: F)

Purpose

Base-16 parsing

Bitwise operations

Expression formatting after calculation

7. Sample Test Output (Successful Run)
00:01 +7: All tests passed!


(Your test output depends on improvements to provider logic).

8. Running Tests

Run full suite:

flutter test


Run a single test by name:

flutter test --plain-name "Memory: 5 M+ 3 M+ MR = 8"

9. Known Testing Limitations

No widget tests (UI-only code)

Expression parser does not yet support:

implicit multiplication (2pi)

factorial (!)

exponent ^ requiring custom handling

Programmer mode does not support chained bitwise expressions fully

10. Future Testing Improvements

Add widget tests for calculator button interactions

Add integration tests for navigation (calculator → history → settings)

Add mock vibration & sound drivers

Increase scientific function coverage

Add stress tests for 1000+ operations

✔ Final Notes

This testing suite ensures the application is:

Stable

Accurate

Predictable

Easy to maintain

The separation of logic and UI allows nearly full test coverage for the brain of the calculator.