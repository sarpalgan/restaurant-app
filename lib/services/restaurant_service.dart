import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../core/models/restaurant.dart';

// Restaurant provider for current user's restaurant
final currentRestaurantProvider = FutureProvider<Restaurant?>((ref) async {
  final user = supabase.auth.currentUser;
  if (user == null) return null;

  final response = await supabase
      .from('restaurants')
      .select()
      .eq('owner_id', user.id)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;
  return Restaurant.fromJson(response);
});

// Restaurant service for CRUD operations
class RestaurantService {
  final SupabaseClient _client = supabase;

  // Create a new restaurant
  Future<Restaurant> createRestaurant({
    required String name,
    required String slug,
    String? logoUrl,
    String? currency,
    String? timezone,
    String? defaultLanguage,
    String? email, // Not stored in DB, just for compatibility
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client.from('restaurants').insert({
      'owner_id': user.id,
      'name': name,
      'slug': slug,
      'logo_url': logoUrl,
      'currency': currency ?? 'USD',
      'timezone': timezone ?? 'UTC',
      'default_language': defaultLanguage ?? 'en',
      'settings': {
        'require_order_confirmation': false,
        'allow_direct_payment': true,
        'auto_accept_orders': true,
      },
    }).select().single();

    return Restaurant.fromJson(response);
  }

  // Update restaurant
  Future<Restaurant> updateRestaurant({
    required String id,
    String? name,
    String? slug,
    String? logoUrl,
    String? currency,
    String? timezone,
    String? defaultLanguage,
    Map<String, dynamic>? settings,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (slug != null) updates['slug'] = slug;
    if (logoUrl != null) updates['logo_url'] = logoUrl;
    if (currency != null) updates['currency'] = currency;
    if (timezone != null) updates['timezone'] = timezone;
    if (defaultLanguage != null) updates['default_language'] = defaultLanguage;
    if (settings != null) updates['settings'] = settings;

    final response = await _client
        .from('restaurants')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    return Restaurant.fromJson(response);
  }

  // Get restaurant by slug (for customer view)
  Future<Restaurant?> getRestaurantBySlug(String slug) async {
    final response = await _client
        .from('restaurants')
        .select()
        .eq('slug', slug)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return Restaurant.fromJson(response);
  }

  // Check if slug is available
  Future<bool> isSlugAvailable(String slug) async {
    final response = await _client
        .from('restaurants')
        .select('id')
        .eq('slug', slug)
        .limit(1)
        .maybeSingle();

    return response == null;
  }
}

// Restaurant service provider
final restaurantServiceProvider = Provider<RestaurantService>((ref) {
  return RestaurantService();
});
