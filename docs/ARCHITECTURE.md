Advanced Calculator – Flutter Application

Author: Tran Phuoc Yen

Student ID: 2224802010093


**1. Overview**

The Advanced Calculator is built using a clean, modular, and scalable architecture based on the MVVM pattern (Model–View–ViewModel), implemented with Provider for reactive state management.

This architecture ensures:
- Clean separation of UI, logic, and data layers
- Testable logic modules
- Reusable UI components
- Easy extension for new modes and features
- Persistent state handling


**2. High-Level Architecture Diagram**

UI Layer (Screens & Widgets)
       
        ↓
        
State Management Layer
  - CalculatorProvider
  - HistoryProvider
  - ThemeProvider

       ↓
    
Logic Layer
  - ExpressionParser
  - CalculatorLogic
  - Base Conversion / Bitwise Logic

        ↓
    
Persistence Layer (StorageService)
  - Save mode/theme
  - Save memory M+/MR
  - Save history items


**3. Layer-by-Layer Explanation**

**3.1 UI Layer (Screens & Widgets)**

📍Screens
- calculator_screen.dart
- history_screen.dart
- settings_screen.dart

📍 Reusable Widgets
- button_grid.dart
- calculator_button.dart
- display_area.dart
- mode_selector.dart

**3.2 State Management Layer (Providers)**

Providers act as ViewModels in MVVM.

📌 Providers used:
- CalculatorProvider
- HistoryProvider
- ThemeProvider

🧩 CalculatorProvider
- Handles core calculator functionalities:
- Expression building
- Expression evaluation
- Scientific functions
- Mode switching: Basic / Scientific / Programmer
- Angle mode (DEG/RAD)
- Memory functions (M+, M-, MR, MC)
- Bitwise operations (AND/OR/XOR/NOT)
- Base conversions (DEC ←→ BIN/OCT/HEX)
- Decimal precision
- Save history

🧩 HistoryProvider
- Load history from persistent storage
- Append new items
- Clear all history
- Provide list to UI

🧩 ThemeProvider
- Dark/Light theme toggle
- Save theme mode persistently

**3.3 Logic Layer**

This layer contains all actual math logic — fully independent of UI.

🧠 ExpressionParser (The Calculator Brain)

Handles:
- Parsing expressions
- Evaluating parentheses
- Operator precedence
- Scientific functions (sin, cos, tan, log, ln, sqrt, etc.)
- Constants (π, e, etc.)
- Custom error reporting

🧠 CalculatorLogic
- Utility helpers for:
- Cleaning expressions
- Pre-check and validation
- Mathematical conversions

🧠 Programmer Mode Logic
- Embedded inside CalculatorProvider:
- Base conversion:
  - DEC ↔ BIN
  - DEC ↔ OCT
  - DEC ↔ HEX
- Bitwise operations:
  - AND
  - OR
  - XOR
  - NOT
- Input validation for different radixes
- Error-safe integer parsing

**3.4 Persistence Layer (StorageService)**

Centralized service for reading/writing persistent data using SharedPreferences.

Handles:
- Save theme mode
- Save calculator mode
- Save angle mode
- Save memory (M+, MR)
- Save calculation history
- Limit history size (FIFO)

**4. Data Flow**

**4.1. User Interaction Flow**
User taps button → UI widget → Provider updates state → UI refreshes

Example:
Press "+" → CalculatorButton → CalculatorProvider.appendToExpression() 
→ notifyListeners() → DisplayArea updates

**4.2. Theme Switching Flow**
User toggles switch → ThemeProvider.toggle() → saveThemeMode() 
→ MaterialApp rebuilds → Theme updated instantly

**4.3. Expression Evaluation Flow**
User presses "="
→ CalculatorProvider.evaluateExpression()
→ ExpressionParser.evaluate()
→ StorageService.saveHistoryItem()
→ UI updates with new result

**4.4. History Flow**
HistoryProvider.loadHistory()
→ StorageService.getHistory()
→ UI ListView displays the items

Selecting a history item:
Tap item → CalculatorProvider.setExpressionValue()
→ Return to calculator → Expression preloaded

