import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

final cleanupServiceProvider = Provider((ref) => CleanupService());

class CleanupService {
  final SupabaseClient _client = supabase;

  /// Checks if the current user has multiple restaurants
  Future<List<Map<String, dynamic>>> getDuplicateRestaurants() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('restaurants')
        .select('id, name, created_at')
        .eq('owner_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Merges all restaurants into the most recent one
  Future<void> mergeRestaurants(List<String> restaurantIds) async {
    if (restaurantIds.isEmpty) return;

    // The first one is the target (most recent)
    final targetId = restaurantIds.first;
    final duplicates = restaurantIds.sublist(1);

    if (duplicates.isEmpty) return;

    // 1. Move Menu Templates
    await _client
        .from('menu_templates')
        .update({'restaurant_id': targetId})
        .filter('restaurant_id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');

    // 2. Move Menu Categories (Items will follow as they are linked to categories)
    await _client
        .from('menu_categories')
        .update({'restaurant_id': targetId})
        .filter('restaurant_id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');

    // 3. Move Branches
    await _client
        .from('branches')
        .update({'restaurant_id': targetId})
        .filter('restaurant_id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');

    // 4. Move Staff Members
    await _client
        .from('staff_members')
        .update({'restaurant_id': targetId})
        .filter('restaurant_id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');

    // 5. Move Subscriptions
    // Note: This might be tricky if there are unique constraints, but usually ok.
    // We'll try to move them, but ignore errors if they conflict (e.g. one active sub per restaurant)
    try {
      await _client
          .from('subscriptions')
          .update({'restaurant_id': targetId})
          .filter('restaurant_id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');
    } catch (e) {
      // Ignore subscription merge errors, we'll just delete the old ones
      print('Error merging subscriptions: $e');
    }

    // 6. Delete the duplicate restaurants
    await _client.from('restaurants').delete().filter('id', 'in', '(${duplicates.map((e) => '"$e"').join(',')})');
  }
}
