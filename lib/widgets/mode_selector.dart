import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalculatorProvider>();

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
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  context,
                  'Basic',
                  cp.mode == CalculatorMode.basic,
                  () => cp.switchCalculatorMode(CalculatorMode.basic),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  context,
                  'Scientific',
                  cp.mode == CalculatorMode.scientific,
                  () => cp.switchCalculatorMode(CalculatorMode.scientific),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  context,
                  'Programmer',
                  cp.mode == CalculatorMode.programmer,
                  () => cp.switchCalculatorMode(CalculatorMode.programmer),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (cp.mode == CalculatorMode.scientific)
                Row(
                  children: [
                    _buildAngleModeButton(
                      context,
                      'DEG',
                      cp.angleMode == 'DEG',
                      () => cp.setDegrees(true),
                    ),
                    SizedBox(width: 6),
                    _buildAngleModeButton(
                      context,
                      'RAD',
                      cp.angleMode == 'RAD',
                      () => cp.setDegrees(false),
                    ),
                  ],
                ),
              if (cp.mode == CalculatorMode.programmer)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: ['BIN', 'OCT', 'DEC', 'HEX'].map((base) {
                      final isSelected = cp.currentNumberBase == base;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: GestureDetector(
                            onTap: () => cp.setNumberBase(base),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: isSelected
                                    ? AppColors.accentColor.withOpacity(0.2)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentColor
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                base,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.accentColor
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (cp.memory != 0.0)
                _buildIndicator(
                  context,
                  'M: ${cp.memory.toStringAsFixed(2)}',
                  AppColors.warningColor,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: AppAnimations.modeSwitchAnimDuration,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAngleModeButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? Colors.blueAccent
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.blueAccent
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
