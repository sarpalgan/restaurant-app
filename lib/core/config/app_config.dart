import 'package:flutter/foundation.dart';

/// Application configuration
class AppConfig {
  AppConfig._();

  // ============================================================
  // SUPABASE CONFIGURATION
  // ============================================================
  
  static const String supabaseUrl = 'https://redqmvgcsxzytqaflclh.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_a8jck92aUmK4uPhcNBYQsg_PwL7fWH0';
  
  // ============================================================
  // STRIPE CONFIGURATION
  // ============================================================
  
  // TODO: Replace with your Stripe publishable key when you create an account
  // Leave empty to use demo/mock mode
  static const String stripePublishableKey = '';
  
  // Platform fee percentage (2.5%)
  static const double platformFeePercent = 0.025;
  
  // ============================================================
  // KIE.AI VIDEO GENERATION
  // ============================================================
  
  // TODO: Add your Kie.ai API key from https://kie.ai/api-key
  // Leave empty to use demo/mock mode with sample videos
  static const String kieApiKey = '';
  static const String kieApiUrl = 'https://api.kie.ai/api/v1/veo/generate';
  
  // Video credit pricing
  static const double videoCreditPrice = 2.0; // USD per video
  
  // ============================================================
  // GOOGLE GEMINI AI (Menu Analysis)
  // ============================================================
  
  // For local development, you can temporarily add your key here
  // For production, use --dart-define=GEMINI_API_KEY=your_key
  // Get your key from https://aistudio.google.com/apikey
  static const String _geminiApiKeyFromEnv = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  
  // TODO: For local testing, you can temporarily paste your key here (DON'T COMMIT!)
  static const String _localGeminiApiKey = '';  // <-- Paste key here for testing
  
  static String get geminiApiKey => 
    _geminiApiKeyFromEnv.isNotEmpty ? _geminiApiKeyFromEnv : _localGeminiApiKey;
  
  // ============================================================
  // DEMO MODE HELPERS
  // ============================================================
  
  /// Check if running in demo mode (no API keys configured)
  static bool get isDemoMode => 
    stripePublishableKey.isEmpty || kieApiKey.isEmpty || geminiApiKey.isEmpty;
  
  static bool get isStripeConfigured => 
    stripePublishableKey.isNotEmpty && stripePublishableKey != 'pk_test_YOUR_STRIPE_KEY';
  
  static bool get isKieConfigured => 
    kieApiKey.isNotEmpty && kieApiKey != 'YOUR_KIE_API_KEY';
  
  static bool get isGeminiConfigured => 
    geminiApiKey.isNotEmpty;
  
  // ============================================================
  // APP CONFIGURATION
  // ============================================================
  
  static const String appName = 'FoodArt';
  static const String customerWebDomain = 'menu.foodart.com';
  
  // Customer web URL builder
  static String getMenuUrl(String restaurantSlug, String tableId) {
    return 'https://$customerWebDomain/$restaurantSlug/$tableId';
  }
  
  // ============================================================
  // SUPPORTED LANGUAGES
  // ============================================================
  
  static const List<String> supportedLanguages = [
    'en', // English
    'es', // Spanish
    'it', // Italian
    'tr', // Turkish
    'ru', // Russian
    'zh', // Chinese (Simplified)
    'de', // German
    'fr', // French
  ];
  
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'it': 'Italiano',
    'tr': 'Türkçe',
    'ru': 'Русский',
    'zh': '中文',
    'de': 'Deutsch',
    'fr': 'Français',
  };
  
  static const Map<String, String> languageFlags = {
    'en': '🇬🇧',
    'es': '🇪🇸',
    'it': '🇮🇹',
    'tr': '🇹🇷',
    'ru': '🇷🇺',
    'zh': '🇨🇳',
    'de': '🇩🇪',
    'fr': '🇫🇷',
  };
  
  // ============================================================
  // PLATFORM DETECTION
  // ============================================================
  
  static bool get isWeb => kIsWeb;
  
  // Deep link scheme for mobile app
  static const String deepLinkScheme = 'io.foodart.app';
  static const String deepLinkHost = 'login-callback';
  
  static String get authRedirectUrl => 
    isWeb ? null.toString() : '$deepLinkScheme://$deepLinkHost/';
  
  // ============================================================
  // SUBSCRIPTION TIERS
  // ============================================================
  
  static const Map<String, SubscriptionTier> subscriptionTiers = {
    'starter': SubscriptionTier(
      id: 'starter',
      name: 'Starter',
      priceMonthly: 29.0,
      maxBranches: 1,
      videoCreditsMonthly: 5,
      features: [
        'Unlimited menu items',
        '1 branch location',
        '5 AI video credits/month',
        'Basic analytics',
        'Email support',
      ],
    ),
    'professional': SubscriptionTier(
      id: 'professional',
      name: 'Professional',
      priceMonthly: 79.0,
      maxBranches: 5,
      videoCreditsMonthly: 20,
      features: [
        'Unlimited menu items',
        'Up to 5 branches',
        '20 AI video credits/month',
        'Advanced analytics',
        'Priority support',
        'Staff management',
      ],
    ),
    'enterprise': SubscriptionTier(
      id: 'enterprise',
      name: 'Enterprise',
      priceMonthly: 199.0,
      maxBranches: -1, // Unlimited
      videoCreditsMonthly: 50,
      features: [
        'Unlimited menu items',
        'Unlimited branches',
        '50 AI video credits/month',
        'Full analytics suite',
        'Dedicated support',
        'White-label option',
        'API access',
      ],
    ),
  };
}

/// Subscription tier model
class SubscriptionTier {
  final String id;
  final String name;
  final double priceMonthly;
  final int maxBranches;
  final int videoCreditsMonthly;
  final List<String> features;

  const SubscriptionTier({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.maxBranches,
    required this.videoCreditsMonthly,
    required this.features,
  });
  
  bool get isUnlimitedBranches => maxBranches == -1;
}
