import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/calculator_button.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({Key? key}) : super(key: key);

  Widget _buildBasicGrid(BuildContext context) {
    final cp = context.read<CalculatorProvider>();
    final rows = ButtonLabels.basicGrid;
    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              return Expanded(
                child: _buildCalculatorButton(
                  context,
                  label,
                  _isOperatorButton(label),
                  () => _handleButtonPress(cp, label),
                  onLongPress: label == 'C'
                      ? () => cp.clearAllHistoryWithConfirm()
                      : null,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScientificGrid(BuildContext context) {
    final cp = context.read<CalculatorProvider>();
    final rows = ButtonLabels.scientificGrid;
    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              return Expanded(
                child: _buildCalculatorButton(
                  context,
                  label,
                  _isOperatorButton(label) || _isMemoryButton(label),
                  () => _handleScientificButtonPress(cp, label),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgrammerGrid(BuildContext context) {
    final cp = context.read<CalculatorProvider>();
    final rows = ButtonLabels.programmerGrid;
    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              return Expanded(
                child: _buildCalculatorButton(
                  context,
                  label,
                  _isProgrammerOperator(label),
                  () => _handleProgrammerButtonPress(cp, label),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(
    BuildContext context,
    String label,
    bool isHighlighted,
    VoidCallback onTap, {
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: EdgeInsets.all(AppDimens.buttonSpacing / 2),
      child: CalculatorButton(
        label: label,
        onPressed: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  bool _isOperatorButton(String label) =>
      RegExp(r'[÷×\-\+\=%]').hasMatch(label) || label == '=';

  bool _isMemoryButton(String label) =>
      RegExp(r'^M[RC\+\-]$|^MC$|^MR$').hasMatch(label);

  bool _isProgrammerOperator(String label) =>
      RegExp(r'^(BIN|OCT|DEC|HEX|AND|OR|XOR|NOT|<<|>>)$').hasMatch(label);

  void _handleButtonPress(CalculatorProvider cp, String label) {
    switch (label) {
      case 'C':
        cp.clearCalculation();
        break;
      case 'CE':
        cp.removeLastCharacter();
        break;
      case '=':
        cp.evaluateExpression();
        break;
      case '±':
        cp.toggleSignOfExpression();
        break;
      case '÷':
        cp.appendToExpression('/');
        break;
      case '×':
        cp.appendToExpression('*');
        break;
      default:
        cp.appendToExpression(label);
    }
  }

  void _handleScientificButtonPress(CalculatorProvider cp, String label) {
    switch (label) {
      case 'C':
        cp.clearCalculation();
        break;
      case 'CE':
        cp.removeLastCharacter();
        break;
      case '=':
        cp.evaluateExpression();
        break;
      case '±':
        cp.toggleSignOfExpression();
        break;
      case 'π':
        cp.appendToExpression('pi');
        break;
      case 'sin':
      case 'cos':
      case 'tan':
        cp.appendToExpression('$label(');
        break;
      case 'x²':
        cp.appendToExpression('^2');
        break;
      case 'x^y':
        cp.appendToExpression('^');
        break;
      case '√':
        cp.appendToExpression('sqrt(');
        break;
      case 'MC':
        cp.memoryClear();
        break;
      case 'MR':
        cp.memoryRecall();
        break;
      case 'M+':
        cp.memoryPlus();
        break;
      case 'M-':
        cp.memoryMinus();
        break;
      case 'Ln':
        cp.appendToExpression('ln(');
        break;
      case 'log':
        cp.appendToExpression('log(');
        break;
      case '÷':
        cp.appendToExpression('/');
        break;
      case '×':
        cp.appendToExpression('*');
        break;
      default:
        cp.appendToExpression(label);
    }
  }

  void _handleProgrammerButtonPress(CalculatorProvider cp, String label) {
    switch (label) {
      case 'C':
        cp.clearCalculation();
        break;
      case 'CE':
        cp.removeLastCharacter();
        break;
      case '=':
        cp.evaluateExpression();
        break;
      case '±':
        cp.toggleSignOfExpression();
        break;
      case 'BIN':
      case 'OCT':
      case 'DEC':
      case 'HEX':
        cp.setNumberBase(label);
        break;
      case 'NOT':
        cp.processBitwiseOperation('NOT');
        break;
      case 'AND':
      case 'OR':
      case 'XOR':
      case '<<':
      case '>>':
        cp.processBitwiseExpression(label);
        break;
      default:
        cp.appendToExpression(label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<CalculatorProvider>().mode;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: mode == CalculatorMode.basic
          ? _buildBasicGrid(context)
          : mode == CalculatorMode.scientific
          ? _buildScientificGrid(context)
          : _buildProgrammerGrid(context),
    );
  }
}
