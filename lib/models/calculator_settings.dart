class CalculatorSettings {
  String theme;
  int decimalPrecision;
  String angleMode;
  bool haptic;
  bool sound;
  int historySize;

  CalculatorSettings({
    this.theme = 'system',
    this.decimalPrecision = 6,
    this.angleMode = 'DEG',
    this.haptic = true,
    this.sound = true,
    this.historySize = 50,
  });
}
