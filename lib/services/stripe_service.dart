import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';

/// Service for Stripe Connect integration
/// Handles restaurant onboarding and payment processing
/// Falls back to mock mode when Stripe is not configured
class StripeService {
  final SupabaseClient _supabase;

  StripeService(this._supabase);
  
  bool get _useMockMode {
    // Check if Stripe keys are configured
    return AppConfig.stripePublishableKey.isEmpty;
  }

  /// Create or retrieve Stripe Connect account for restaurant
  /// Returns the onboarding URL for the restaurant owner
  Future<String?> createConnectAccount({
    required String restaurantId,
    required String returnUrl,
    required String refreshUrl,
  }) async {
    if (_useMockMode) {
      debugPrint('StripeService: Mock mode - Stripe not configured');
      // Return null to indicate Stripe is not available
      return null;
    }
    
    try {
      final response = await _supabase.functions.invoke(
        'create-connect-account',
        body: {
          'restaurantId': restaurantId,
          'returnUrl': returnUrl,
          'refreshUrl': refreshUrl,
        },
      );

      if (response.status != 200) {
        throw Exception(response.data['error'] ?? 'Failed to create Connect account');
      }

      return response.data['url'] as String?;
    } catch (e) {
      debugPrint('Error creating Connect account: $e');
      rethrow;
    }
  }

  /// Create a payment intent for an order
  /// Returns the client secret for Stripe Elements
  Future<PaymentIntentResult?> createPaymentIntent({
    required String orderId,
  }) async {
    if (_useMockMode) {
      debugPrint('StripeService: Mock mode - returning mock payment intent');
      // Return mock result for demo purposes
      return PaymentIntentResult(
        clientSecret: 'mock_client_secret_${DateTime.now().millisecondsSinceEpoch}',
        paymentIntentId: 'mock_pi_${DateTime.now().millisecondsSinceEpoch}',
        publishableKey: 'pk_test_mock',
        isMock: true,
      );
    }
    
    try {
      final response = await _supabase.functions.invoke(
        'create-payment-intent',
        body: {
          'orderId': orderId,
        },
      );

      if (response.status != 200) {
        throw Exception(response.data['error'] ?? 'Failed to create payment intent');
      }

      return PaymentIntentResult(
        clientSecret: response.data['clientSecret'] as String,
        paymentIntentId: response.data['paymentIntentId'] as String,
        publishableKey: response.data['publishableKey'] as String?,
      );
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      rethrow;
    }
  }
  
  /// Simulate payment completion (for mock mode)
  Future<bool> simulatePaymentCompletion(String orderId) async {
    if (!_useMockMode) return false;
    
    try {
      // Update order payment status directly in demo mode
      await _supabase
          .from('orders')
          .update({'payment_status': 'paid'})
          .eq('id', orderId);
      return true;
    } catch (e) {
      debugPrint('Error simulating payment: $e');
      return false;
    }
  }

  /// Check Stripe Connect account status
  Future<StripeAccountStatus> getAccountStatus(String restaurantId) async {
    if (_useMockMode) {
      return StripeAccountStatus.notConfigured;
    }
    
    try {
      final result = await _supabase
          .from('restaurants')
          .select('stripe_account_id, stripe_account_status')
          .eq('id', restaurantId)
          .single();

      final accountId = result['stripe_account_id'] as String?;
      final status = result['stripe_account_status'] as String?;

      if (accountId == null) {
        return StripeAccountStatus.notCreated;
      }

      switch (status) {
        case 'active':
          return StripeAccountStatus.active;
        case 'restricted':
          return StripeAccountStatus.restricted;
        case 'pending':
        default:
          return StripeAccountStatus.pending;
      }
    } catch (e) {
      debugPrint('Error getting account status: $e');
      return StripeAccountStatus.notCreated;
    }
  }

  /// Get dashboard login link for restaurant's Stripe account
  Future<String?> getStripeDashboardLink(String restaurantId) async {
    if (_useMockMode) {
      return null;
    }
    
    try {
      final response = await _supabase.functions.invoke(
        'get-stripe-dashboard-link',
        body: {
          'restaurantId': restaurantId,
        },
      );

      if (response.status != 200) {
        throw Exception(response.data['error'] ?? 'Failed to get dashboard link');
      }

      return response.data['url'] as String?;
    } catch (e) {
      debugPrint('Error getting dashboard link: $e');
      return null;
    }
  }
}

/// Result of creating a payment intent
class PaymentIntentResult {
  final String clientSecret;
  final String paymentIntentId;
  final String? publishableKey;
  final bool isMock;

  PaymentIntentResult({
    required this.clientSecret,
    required this.paymentIntentId,
    this.publishableKey,
    this.isMock = false,
  });
}

/// Stripe Connect account status
enum StripeAccountStatus {
  notConfigured, // Stripe keys not set
  notCreated,
  pending,
  active,
  restricted,
}
