**🧪 TESTING.md**

**Advanced Calculator – Flutter Application**

**Author: Tran Phuoc Yen**

**Student ID: 2224802010093**

**1. Overview**

This document describes the testing strategy, methodology, mocking system, and test cases implemented for the Advanced Calculator Flutter Application.

Testing ensures:
- Reliability of mathematical operations
- Correctness of scientific & programmer functions
- Stability of state management (Provider)
- Accuracy of the custom expression parser
- Proper functionality of persistent storage
- Predictable behavior under complex input
  
All tests are located in:
  /test/flutter_test.dart

**2. Testing Methodology**

The project applies three major categories of testing.

**2.1 Unit Testing (Primary Focus)**

Unit tests ensure correctness of:
- ExpressionParser
- CalculatorProvider
- Memory operations (M+, MR, MC)
- Angle mode switching (DEG ↔ RAD)
- Programmer mode logic (bitwise + base conversion)
- Number formatting and result cleanup

These tests run independently from UI and without SharedPreferences.

**2.2 Integration Testing (Partial)**

Covers interaction between:
- Provider ↔ Parser
- Provider ↔ FakeStorage
- Continuous chain calculations
- History persistence
  
Ensures modules behave correctly when combined.

**2.3 No Widget/UI Tests**

Reason:
- UI layer is purely presentational
- All logic is inside Providers (fully testable)
- UI state is reactive → testing logic = testing UI behavior
- Keeps the suite simple and maintainable

**3. Tools & Environment**

Component	- Version / Usage

Flutter - SDK	3.x+

Dart Test Framework	- flutter_test

State Management - Provider

Mock Storage - FakeStorage

OS Tested	- Android Emulator

Run all tests:
flutter test

**3. Detailed Test Cases**

Below is the complete, categorized list of test cases.

**3.1. Complex Arithmetic Expressions**

(5+3) * 2 - 4 / 2 = 14

<img width="430" height="791" alt="image" src="https://github.com/user-attachments/assets/b012e404-04d1-4982-9c8c-11fd3841536f" />

Purpose:
- Operator precedence
- Mixed operations
- Parser correctness

**3.2. Scientific Functions**

Test:

sin(45) + cos(45) ≈ 1.414

<img width="430" height="789" alt="image" src="https://github.com/user-attachments/assets/086cb64a-e419-4ffd-b47d-4248c592b87c" />

Angle mode = DEG

Purpose:
- Trigonometric accuracy
- Function parsing
- DEG/RAD correctness

**3.3. Mixed Scientific Expressions**

Test:

2 * π * sqrt(9) ≈ 18.85

<img width="431" height="787" alt="image" src="https://github.com/user-attachments/assets/1e7aa250-7522-4cb6-b34e-70de9c84af41" />

Purpose:
- Constant replacement (pi)
- Function evaluation (sqrt)
- Mixed operations

**3.3. Programmer Mode Logic**

Test:

HEX: FF AND 0F → F

<img width="433" height="795" alt="image" src="https://github.com/user-attachments/assets/4d3600ac-f776-4b71-beba-dcd3d92a416a" />

Purpose:
- Base-16 parsing
- Bitwise computation
- Expression formatting

**3.4. Example Successful Output**

<img width="827" height="83" alt="image" src="https://github.com/user-attachments/assets/9ebe147a-bf46-4549-bab2-9ecf59e89528" />

**4. Running Tests**

Run full suite: flutter test

**5. Known Testing Limitations**

- No UI widget tests
- Parser does not support:
- Implicit multiplication (2pi)
- Factorial (n!)
- Multi-operator bitwise chaining
- Programmer mode currently processes one binary op at a time

**6. Future Testing Improvements**

- Add widget interaction tests (button press simulation)
- Add navigation tests across screens
- Add performance & stress tests
- Add mock sound & vibration drivers
- Expand scientific function test matrix
- Add snapshot-style regression tests
