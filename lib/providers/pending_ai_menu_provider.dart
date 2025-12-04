import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/pending_ai_menu_result.dart';

const _storageKey = 'pending_ai_menu_results';

/// Provider for pending AI menu results
final pendingAIMenuResultsProvider = StateNotifierProvider<PendingAIMenuResultsNotifier, List<PendingAIMenuResult>>((ref) {
  return PendingAIMenuResultsNotifier();
});

/// Get a specific pending result by ID
final pendingAIMenuResultByIdProvider = Provider.family<PendingAIMenuResult?, String>((ref, id) {
  final results = ref.watch(pendingAIMenuResultsProvider);
  try {
    return results.firstWhere((r) => r.id == id);
  } catch (e) {
    return null;
  }
});

class PendingAIMenuResultsNotifier extends StateNotifier<List<PendingAIMenuResult>> {
  PendingAIMenuResultsNotifier() : super([]) {
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        state = jsonList
            .map((json) => PendingAIMenuResult.fromJson(json as Map<String, dynamic>))
            .where((r) => r.status != AIMenuResultStatus.expired)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
      }
    } catch (e) {
      // If loading fails, start with empty list
      state = [];
    }
  }

  Future<void> _saveResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.map((r) => r.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Add a new pending result
  Future<void> addResult(PendingAIMenuResult result) async {
    state = [result, ...state];
    await _saveResults();
  }

  /// Update a result
  Future<void> updateResult(PendingAIMenuResult result) async {
    state = state.map((r) {
      if (r.id == result.id) {
        return result;
      }
      return r;
    }).toList();
    await _saveResults();
  }

  /// Mark a result as completed
  Future<void> markCompleted(String id) async {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: AIMenuResultStatus.completed);
      }
      return r;
    }).toList();
    await _saveResults();
  }

  /// Mark a result as imported
  Future<void> markImported(String id) async {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: AIMenuResultStatus.imported);
      }
      return r;
    }).toList();
    await _saveResults();
  }

  /// Mark a result as saved (template)
  Future<void> markSaved(String id) async {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: AIMenuResultStatus.saved);
      }
      return r;
    }).toList();
    await _saveResults();
  }

  /// Remove a result
  Future<void> removeResult(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _saveResults();
  }

  /// Get result by ID
  PendingAIMenuResult? getById(String id) {
    try {
      return state.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get pending results (not yet completed or failed)
  List<PendingAIMenuResult> get pendingResults {
    return state.where((r) => r.status == AIMenuResultStatus.pending).toList();
  }

  /// Get completed results (ready to view)
  List<PendingAIMenuResult> get completedResults {
    return state.where((r) => r.status == AIMenuResultStatus.completed).toList();
  }

  /// Clean up old results (older than 7 days)
  Future<void> cleanupOldResults() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    state = state.where((r) {
      if (r.createdAt.isBefore(cutoff) && 
          (r.status == AIMenuResultStatus.completed || r.status == AIMenuResultStatus.pending)) {
        return false;
      }
      return true;
    }).toList();
    await _saveResults();
  }
}
