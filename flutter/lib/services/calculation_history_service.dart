import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html show window;

class CalculationResult {
  final String method; // 'Pinch' or 'CT'
  final double result;
  final DateTime timestamp;
  final Map<String, double> inputs;

  CalculationResult({
    required this.method,
    required this.result,
    required this.timestamp,
    required this.inputs,
  });

  Map<String, dynamic> toJson() => {
        'method': method,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
        'inputs': inputs,
      };

  factory CalculationResult.fromJson(Map<String, dynamic> json) {
    return CalculationResult(
      method: json['method'],
      result: (json['result'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      inputs: (json['inputs'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }
}

class CalculationHistoryService {
  static const String _historyKey = 'calculation_history';
  static const int _maxHistorySize = 10;

  Future<void> addCalculation(CalculationResult result) async {
    final history = await getHistory();
    
    // Add new calculation at the beginning
    history.insert(0, result);
    
    // Keep only last 10 calculations
    if (history.length > _maxHistorySize) {
      history.removeRange(_maxHistorySize, history.length);
    }
    
    // Save to storage
    final jsonList = history.map((r) => json.encode(r.toJson())).toList();
    
    if (kIsWeb) {
      // Use localStorage directly on web
      html.window.localStorage[_historyKey] = json.encode(jsonList);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, jsonList);
    }
  }

  Future<List<CalculationResult>> getHistory() async {
    List<String> jsonList;
    
    if (kIsWeb) {
      // Use localStorage directly on web
      final stored = html.window.localStorage[_historyKey];
      if (stored != null) {
        jsonList = List<String>.from(json.decode(stored));
      } else {
        jsonList = [];
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      jsonList = prefs.getStringList(_historyKey) ?? [];
    }
    
    return jsonList.map((jsonStr) {
      final jsonMap = json.decode(jsonStr);
      return CalculationResult.fromJson(jsonMap);
    }).toList();
  }

  Future<void> clearHistory() async {
    if (kIsWeb) {
      html.window.localStorage.remove(_historyKey);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    }
  }
}
