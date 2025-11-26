import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class ExpressionParser {
  final Parser _parser = Parser();

  double evaluate(String expression, {String angleMode = 'DEG'}) {
    String s = _preprocess(expression);

    if (_hasBitwiseOperation(s)) {
      return _evaluateBitwise(s);
    }

    if (angleMode == 'DEG') {
      s = _convertTrigDegrees(s);
    }

    s = _replaceFactWithNumber(s);

    Expression exp = _parser.parse(s);
    ContextModel cm = ContextModel()
      ..bindVariableName('pi', Number(math.pi))
      ..bindVariableName('e', Number(math.e));

    final result = exp.evaluate(EvaluationType.REAL, cm);

    if (result is num) return result.toDouble();
    throw Exception("Non-numeric result");
  }

  String _preprocess(String s) {
    s = s.replaceAll('×', '*').replaceAll('÷', '/');
    s = s.replaceAll('π', 'pi');
    s = s.replaceAll('PI', 'pi');

    s = s.replaceAll('−', '-');

    s = s.replaceAllMapped(RegExp(r'(\d|\))(\()'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(\d)(pi|e)'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(pi|e)(\d|\()'), (m) => '${m[1]}*${m[2]}');

    s = s.replaceAllMapped(RegExp(r'(\d+)!'), (m) => 'fact(${m[1]})');

    return s;
  }

  String _convertTrigDegrees(String s) {
    s = s.replaceAllMapped(
      RegExp(r'sin\(([^)]+)\)'),
      (m) => 'sin((${m[1]})*pi/180)',
    );

    s = s.replaceAllMapped(
      RegExp(r'cos\(([^)]+)\)'),
      (m) => 'cos((${m[1]})*pi/180)',
    );

    s = s.replaceAllMapped(
      RegExp(r'tan\(([^)]+)\)'),
      (m) => 'tan((${m[1]})*pi/180)',
    );

    return s;
  }

  String _replaceFactWithNumber(String s) {
    return s.replaceAllMapped(RegExp(r'fact\((\d+)\)'), (m) {
      int n = int.parse(m[1]!);
      return _fact(n).toString();
    });
  }

  int _fact(int n) {
    if (n < 0) throw Exception("factorial negative");
    int r = 1;
    for (int i = 1; i <= n; i++) r *= i;
    return r;
  }

  bool _hasBitwiseOperation(String expression) {
    return RegExp(r'(AND|OR|XOR|<<|>>)').hasMatch(expression);
  }

  double _evaluateBitwise(String expression) {
    try {
      final tokens = expression.split(RegExp(r'\s+'));
      int result = int.parse(tokens[0]);

      for (int i = 1; i < tokens.length - 1; i += 2) {
        String op = tokens[i];
        int val = int.parse(tokens[i + 1]);

        switch (op) {
          case 'AND':
            result &= val;
            break;
          case 'OR':
            result |= val;
            break;
          case 'XOR':
            result ^= val;
            break;
          case '<<':
            result <<= val;
            break;
          case '>>':
            result >>= val;
            break;
          default:
            throw Exception("Unknown bitwise op");
        }
      }

      return result.toDouble();
    } catch (e) {
      throw Exception("Bitwise error: $e");
    }
  }
}
