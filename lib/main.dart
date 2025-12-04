import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'services/background_ai_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize Stripe (only for mobile, not web, and only if key is configured)
  if (!AppConfig.isWeb && AppConfig.isStripeConfigured) {
    Stripe.publishableKey = AppConfig.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  // Initialize notification service for background AI processing
  await NotificationService().initialize();

  // Create the provider container
  final container = ProviderContainer();
  
  // Set up the background AI service with the provider container
  // This allows it to save results even when UI is not active
  BackgroundAIService.setProviderContainer(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FoodArtApp(),
    ),
  );
}

// Global Supabase client accessor
final supabase = Supabase.instance.client;
