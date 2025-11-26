import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? color;

  const CalculatorButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.color,
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onButtonDown() {
    _pressController.forward();
  }

  void _onButtonUp() {
    _pressController.reverse();
  }

  Color _getButtonColor(String label) {
    if (['+', '-', '×', '÷', '=', '%'].contains(label)) {
      return Color(0xFFFF6B6B);
    }
    if ([
      'sin',
      'cos',
      'tan',
      'asin',
      'acos',
      'atan',
      'ln',
      'log',
      'log₂',
      'log2',
      'π',
      'e',
      '√',
      'x²',
      'x³',
      '^',
      'n!',
      '!',
      'mod',
      '(',
      ')',
    ].contains(label)) {
      return Color(0xFF4ECDC4);
    }
    if (['AND', 'OR', 'XOR', 'NOT', '<<', '>>'].contains(label)) {
      return Color(0xFF9B59B6);
    }
    if (['Dec', 'Bin', 'Oct', 'Hex'].contains(label)) {
      return Color(0xFF1ABC9C);
    }
    if ([
      'MC',
      'MR',
      'M+',
      'M-',
      'AC',
      'C',
      'DEL',
      'CE',
      '2nd',
      '±',
    ].contains(label)) {
      return Color(0xFFE74C3C);
    }
    return Color(0xFF424242);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getButtonColor(widget.label);

    return GestureDetector(
      onTapDown: (_) => _onButtonDown(),
      onTapUp: (_) {
        _onButtonUp();
        widget.onPressed?.call();
      },
      onTapCancel: _onButtonUp,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: const EdgeInsets.all(4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            disabledBackgroundColor: bgColor,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
