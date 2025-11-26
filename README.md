📱 Advanced Calculator – Flutter Application

Author: Tran Phuoc Yen
Student ID: 2224802010093
Course: Advanced Mobile Application Development
Project: Flutter Advanced Calculator

⭐ Overview

The Advanced Calculator is a multifunctional Flutter application designed to simulate a modern, feature-rich calculator.

It includes:

Basic, Scientific, and Programmer modes

History tracking

Memory functions (M+, M-, MR, MC)

Theme switching (Light/Dark)

Complex expression parsing

Unit-test coverage for core logic

This project demonstrates:

State management using Provider

Persistent storage using SharedPreferences

Custom math expression parsing engine

Clean architecture separation

UI/UX best practices

Unit testing for accurate mathematical logic

✨ Features
🔹 1. Basic Calculator Mode

Supports common arithmetic:

Addition, subtraction

Multiplication, division

Percentage, sign toggle

Multi-step expressions

🔹 2. Scientific Calculator Mode

Includes advanced mathematical functions:

sin, cos, tan (DEG / RAD)

sqrt, log, ln, exp

pi, parentheses, nested expressions

Angle mode toggle (DEG ↔ RAD)

🔹 3. Programmer Calculator Mode

Supports developer-oriented number systems:

DEC / BIN / OCT / HEX base conversion

Bitwise operations:

AND

OR

XOR

NOT

Accurate integer parsing & conversions.

🔹 4. Memory Functions

M+ Add to memory

M- Subtract from memory

MR Recall memory

MC Clear memory

Memory is saved persistently.

🔹 5. History System

Automatically saves all past calculations

Single-tap to re-use a history expression

Clear-all with confirmation

Persisted locally

🔹 6. Theme & Settings

Light / Dark mode

Decimal precision control

Angle mode toggle (DEG / RAD)

History size configuration

Optional haptic feedback

📂 Project Structure
flutter_advanced_calculator/
├── docs
│   ├── ARCHITECTURE.md
│   └── TESTING.md
│
├── lib
│   ├── models
│   │   ├── calculation_history.dart
│   │   ├── calculator_mode.dart
│   │   └── calculator_settings.dart
│   │
│   ├── providers
│   │   ├── calculator_provider.dart
│   │   ├── history_provider.dart
│   │   └── theme_provider.dart
│   │
│   ├── screens
│   │   ├── calculator_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── services
│   │   └── storage_service.dart
│   │
│   ├── utils
│   │   ├── calculator_logic.dart
│   │   ├── constants.dart
│   │   └── expression_parser.dart
│   │
│   ├── widgets
│   │   ├── button_grid.dart
│   │   ├── calculator_button.dart
│   │   ├── display_area.dart
│   │   └── mode_selector.dart
│   │
│   └── main.dart
│
└── test
│   └── flutter_test.dart
│
├── screenshots/
├── pubspec.yaml
└── README.md