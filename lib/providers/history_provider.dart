import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/calculation_history.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService storage;
  List<CalculationHistory> items = [];

  HistoryProvider({required this.storage}) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    items = await storage.getHistory();
    notifyListeners();
  }

  Future<void> clear() async {
    await storage.clearHistory();
    items = [];
    notifyListeners();
  }

  Future<void> addHistoryItem(CalculationHistory item) async {
    await storage.saveHistoryItem(item);
  }
}
