import 'package:flutter/material.dart';

class DisplayArea extends StatefulWidget {
  final String expression;
  final String result;
  final bool hasMemory;
  final bool isDegrees;
  final String? error;
  final VoidCallback? onSwipeDelete;

  const DisplayArea({
    Key? key,
    this.expression = '',
    this.result = '',
    this.hasMemory = false,
    this.isDegrees = true,
    this.error,
    this.onSwipeDelete,
  }) : super(key: key);

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnim;
  late Animation<double> _shakeAnim;
  double _fontSize = 18.0; // For pinch-to-zoom
  double _minFontSize = 14.0;
  double _maxFontSize = 32.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticInOut),
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(DisplayArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expression != widget.expression ||
        oldWidget.error != widget.error) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatExpressionDisplay(String expr) {
    String formatted = expr;
    formatted = formatted.replaceAll('*', '×');
    formatted = formatted.replaceAll('/', '÷');
    formatted = formatted.replaceAll('pi', 'π');
    formatted = formatted.replaceAll('sqrt(', '√(');
    formatted = formatted.replaceAll('PI', 'π');
    formatted = formatted.replaceAll('SQRT(', '√(');
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.error != null && widget.error!.isNotEmpty;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0 && widget.onSwipeDelete != null) {
          widget.onSwipeDelete!();
        }
      },
      onScaleUpdate: (details) {
        if (details.scale != 1.0) {
          setState(() {
            final newSize = _fontSize * details.scale;
            _fontSize = newSize.clamp(_minFontSize, _maxFontSize);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: hasError
              ? Colors.red.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceVariant,
          border: Border.all(
            color: hasError
                ? Colors.red.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.hasMemory)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'M',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.isDegrees ? 'DEG' : 'RAD',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (widget.expression.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ScaleTransition(
                    scale: _slideAnim,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatExpressionDisplay(widget.expression),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        fontSize: _fontSize * 0.85,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),

              if (widget.result.isNotEmpty && !hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: FadeTransition(
                    opacity: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.result,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                                fontSize: _fontSize * 1.5,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),

              if (hasError)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.05, 0),
                    end: const Offset(0.05, 0),
                  ).animate(_shakeAnim),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      widget.error!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ColorWithValues on Color {
  Color withValues({int? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(
      alpha ?? this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
