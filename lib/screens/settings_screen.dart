import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _precision;
  late bool _haptic;
  late bool _sound;
  late bool _degrees;
  late int _historySize;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    _degrees = provider.degrees;
    _precision = 4;
    _haptic = true;
    _sound = false;
    _historySize = 50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "←",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: const Text('Cài Đặt'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<ThemeProvider>(
            builder: (context, theme, _) => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle light/dark theme'),
              value: theme.isDark,
              onChanged: (_) => theme.toggle(),
            ),
          ),
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Decimal Precision: $_precision',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _precision.toDouble(),
                  min: 2,
                  max: 10,
                  divisions: 8,
                  label: '$_precision',
                  onChanged: (v) => setState(() => _precision = v.toInt()),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Consumer<CalculatorProvider>(
            builder: (context, calc, _) => SwitchListTile(
              title: const Text('Angle Mode'),
              subtitle: const Text('DEG (on) / RAD (off)'),
              value: _degrees,
              onChanged: (v) {
                setState(() => _degrees = v);
                calc.setDegrees(v);
              },
            ),
          ),
          const Divider(height: 24),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibration on button press'),
            value: _haptic,
            onChanged: (v) => setState(() => _haptic = v),
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Audio feedback (if enabled)'),
            value: _sound,
            onChanged: (v) => setState(() => _sound = v),
          ),
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History Size: $_historySize',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _historySize.toDouble(),
                  min: 25,
                  max: 100,
                  divisions: 3,
                  label: '$_historySize',
                  onChanged: (v) => setState(() => _historySize = v.toInt()),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showClearDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Clear All History',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<HistoryProvider>(
                context,
                listen: false,
              ).clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('History cleared')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
