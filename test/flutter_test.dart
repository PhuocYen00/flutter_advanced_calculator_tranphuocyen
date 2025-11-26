import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_calculator/providers/calculator_provider.dart';
import 'package:advanced_calculator/utils/expression_parser.dart';
import 'package:advanced_calculator/services/storage_service.dart';
import 'package:advanced_calculator/models/calculation_history.dart';
import 'package:advanced_calculator/models/calculator_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CalculatorProvider calc;
  late ExpressionParser parser;

  final storage = FakeStorage();

  setUp(() {
    parser = ExpressionParser();
    calc = CalculatorProvider(
      storage: storage,
      parser: parser,
      autoInit: false,
    );

    calc.expression = "";
    calc.previousResult = "";
    calc.errorMessage = null;
  });

  test("Complex: (5+3)*2 - 4/2 = 14", () async {
    calc.appendToExpression("(5+3)*2 - 4/2");
    await calc.evaluateExpression();

    expect(calc.expression, "14");
  });

  test("Scientific: sin(45) + cos(45) ≈ 1.414", () async {
    calc.angleMode = "DEG";

    calc.appendToExpression("sin(45)+cos(45)");
    await calc.evaluateExpression();

    final v = double.parse(calc.expression);
    expect((v - 1.414).abs() < 0.01, true);
  });

  test("Memory: 5 M+ 3 M+ MR = 8", () async {
    calc.appendToExpression("5");
    await calc.evaluateExpression();
    calc.memoryPlus();

    calc.appendToExpression("3");
    await calc.evaluateExpression();
    calc.memoryPlus();

    calc.memoryRecall();
    expect(calc.expression, "8");
  });

  test("Chain: 5+3 = +2 = +1 = 11", () async {
    calc.appendToExpression("5+3");
    await calc.evaluateExpression();

    calc.appendToExpression("+2");
    await calc.evaluateExpression();

    calc.appendToExpression("+1");
    await calc.evaluateExpression();

    expect(calc.expression, "11");
  });

  test("Parentheses: ((2+3)*(4-1))/5 = 3", () async {
    calc.appendToExpression("((2+3)*(4-1))/5");
    await calc.evaluateExpression();

    expect(calc.expression, "3");
  });

  test("Mixed scientific: 2*pi*sqrt(9) ≈ 18.85", () async {
    calc.appendToExpression("2*pi*sqrt(9)");
    await calc.evaluateExpression();

    final v = double.parse(calc.expression);
    expect((v - 18.85).abs() < 0.05, true);
  });

  test("Programmer mode: FF AND 0F = 0F", () async {
    calc.currentNumberBase = "HEX";

    calc.expression = "FF";
    calc.processBitwiseExpression("AND");
    calc.appendToExpression("0F");

    await calc.evaluateExpression();

    expect(calc.expression.toUpperCase(), "F");
  });
}

class FakeStorage extends StorageService {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> saveAngleMode(String mode) async {
    _data['angleMode'] = mode;
  }

  @override
  Future<String?> getAngleMode() async {
    return _data['angleMode'];
  }

  @override
  Future<void> saveMemory(double value) async {
    _data['memory'] = value;
  }

  @override
  Future<double?> getMemory() async {
    return _data['memory'];
  }

  @override
  Future<void> saveMode(CalculatorMode mode) async {
    _data['mode'] = mode;
  }

  @override
  Future<CalculatorMode?> getMode() async {
    return _data['mode'];
  }

  @override
  Future<void> saveHistoryItem(
    CalculationHistory item, {
    int maxItems = 50,
  }) async {
    _data.putIfAbsent("history", () => <CalculationHistory>[]);

    final list = _data["history"] as List<CalculationHistory>;
    list.add(item);

    if (list.length > maxItems) {
      list.removeAt(0);
    }
  }

  @override
  Future<List<CalculationHistory>> getHistory() async {
    return List<CalculationHistory>.from(_data["history"] ?? []);
  }

  @override
  Future<void> clearHistory() async {
    _data["history"] = <CalculationHistory>[];
  }

  @override
  Future<void> saveDecimalPrecision(int p) async {}

  @override
  Future<int?> getDecimalPrecision() async {
    return 6;
  }

  @override
  Future<void> saveHaptic(bool enabled) async {}

  @override
  Future<bool?> getHaptic() async {
    return false;
  }
}
