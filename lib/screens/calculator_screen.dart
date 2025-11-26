import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<CalculatorProvider>();
    final cp = context.read<CalculatorProvider>();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.screenPadding),
          child: Column(
            children: [
              ModeSelector(),
              SizedBox(height: 20),
              DisplayArea(
                expression: cp.expression,
                result: cp.previousResult,
                hasMemory: cp.hasMemoryValue,
                isDegrees: cp.degrees,
                error: cp.errorMessage,
                onSwipeDelete: () => cp.removeLastCharacter(),
              ),
              SizedBox(height: 24),
              Expanded(child: ButtonGrid()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Máy Tính Nâng Cao'),
            SizedBox(height: 2),
            Text(
              'Advanced Scientific Calculator',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/history'),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text('📋', style: TextStyle(fontSize: 18)),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/settings'),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text('⚙️', style: TextStyle(fontSize: 18)),
          ),
        ),
        SizedBox(width: 8),
      ],
      elevation: 4,
    );
  }
}
