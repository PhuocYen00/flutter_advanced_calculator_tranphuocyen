🏛️ ARCHITECTURE.md

Advanced Calculator – Flutter Application
Author: Tran Phuoc Yen
Student ID: 2224802010093

1. Overview

The Advanced Calculator is architected using a modular, scalable, and maintainable structure based on the MVVM (Model–View–ViewModel) pattern combined with Provider for reactivity.

The architecture ensures:

Clean separation of responsibilities

Easy testing of logic modules

Reusable components and widgets

Extendability for additional modes or features

Full support for state persistence

2. High-Level Architecture Diagram
┌──────────────────────────────┐
│          UI Layer            │
│  (Screens & Widgets)         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     State Management Layer    │
│     Providers (ViewModels)   │
│  - CalculatorProvider         │
│  - HistoryProvider            │
│  - ThemeProvider              │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│         Logic Layer           │
│   - ExpressionParser          │
│   - CalculatorLogic           │
│   - Base Conversion / Bitwise │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Persistence Layer       │
│   StorageService (SharedPref) │
│   - Save mode / theme         │
│   - Save memory M+/MR         │
│   - Save history items        │
└──────────────────────────────┘

3. Layer-by-Layer Explanation
3.1 UI Layer (Screens & Widgets)

This layer contains:

calculator_screen.dart

history_screen.dart

settings_screen.dart

and reusable widgets:

button_grid.dart

calculator_button.dart

display_area.dart

mode_selector.dart

Responsibilities:

Displays data from Provider

Sends user actions to Providers

Contains NO business logic

UI only (pure presentation)

Why?
Keeps UI clean and testable.

3.2 State Management Layer (Providers)

Includes:

CalculatorProvider

Core state manager. Handles:

Expression building

Calculation logic

Mode switching

Angle mode (DEG/RAD)

Memory functions

Programmer operations

Decimal precision

History saving (via StorageService)

HistoryProvider

Loads saved history list

Adds new history

Clears all history

ThemeProvider

Saves & toggles Light/Dark mode

Syncs with persistent storage

Why Provider?

Lightweight and fast

Recommended by official Flutter team

Easy to test

No boilerplate

Perfect for calculators where UI changes frequently

3.3 Logic Layer

This layer contains all logic without UI:

ExpressionParser.dart – The Brain of the Calculator

Handles:

Parsing mathematical expressions

Scientific functions:
sin, cos, tan, log, ln, sqrt, etc.

Operator precedence

Evaluating nested parentheses

Replacing constants like pi

This module is 100% testable, independent of UI.

CalculatorLogic.dart

Helper functions

Validation

Mathematical utilities

Programmer Mode Logic

Included inside CalculatorProvider:

Base conversions (DEC/BIN/OCT/HEX)

Bitwise operations:

AND

OR

XOR

NOT

Radix parsing (2, 8, 10, 16)

Error handling for invalid formats

3.4 Persistence Layer (StorageService)

Centralized service for reading/writing persistent data using SharedPreferences.

Handles:

Save theme mode

Save calculator mode

Save angle mode

Save memory (M+, MR)

Save calculation history

Limit history size (FIFO)

Why a service class?

Decouples storage from logic

Easy to mock for unit testing

Clean and isolated

4. Data Flow
🔁 1. User Interaction Flow
User taps button → UI widget → Provider updates state → UI refreshes


Example:

Press "+" → CalculatorButton → CalculatorProvider.appendToExpression() 
→ notifyListeners() → DisplayArea updates

🔄 2. Theme Switching Flow
User toggles switch → ThemeProvider.toggle() → saveThemeMode() 
→ MaterialApp rebuilds → Theme updated instantly

🧠 3. Expression Evaluation Flow
User presses "="
→ CalculatorProvider.evaluateExpression()
→ ExpressionParser.evaluate()
→ StorageService.saveHistoryItem()
→ UI updates with new result

💾 4. History Flow
HistoryProvider.loadHistory()
→ StorageService.getHistory()
→ UI ListView displays the items


Selecting a history item:

Tap item → CalculatorProvider.setExpressionValue()
→ Return to calculator → Expression preloaded

5. Error Handling

Handled in CalculatorProvider:

Invalid expressions

Division-by-zero

Invalid base conversion

Bitwise errors

Parser exceptions

UI shows error messages without crashing the app.

6. Testing Architecture

A dedicated test suite exists in /test/flutter_test.dart.

Includes:

Complex expressions

Scientific calculations

Memory functions

Chain evaluations

Nested parentheses

Programmer mode bitwise operations

Base conversions

StorageService is replaced with a FakeStorage to bypass SharedPreferences.

7. Future Improvements

Add graphing calculator mode

Add matrix and vector operations

Add voice input

Add keyboard shortcuts for desktop

Support for history export/import

Add animations + haptic vibrations

Improve scientific parser for more functions

8. Why This Architecture?
Reason	Benefit
Clear separation of layers	Easier debugging & scaling
Provider for state	High performance, minimal boilerplate
Isolated parser	Reliable unit testing
Storage service abstraction	Mockable & test-friendly
Widget modularization	Clean UI & reusable components
✔ Final Notes

This architecture is designed to be:

Scalable (easy to add features)

Maintainable (clean modular code)

Testable (logic separated from UI)

Beginner-friendly but also industry-standard