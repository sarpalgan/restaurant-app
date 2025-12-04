import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'l10n/app_localizations.dart';
import 'services/language_service.dart';
import 'services/notification_service.dart';

class FoodArtApp extends ConsumerStatefulWidget {
  const FoodArtApp({super.key});

  @override
  ConsumerState<FoodArtApp> createState() => _FoodArtAppState();
}

class _FoodArtAppState extends ConsumerState<FoodArtApp> {
  StreamSubscription<String>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
    _checkPendingNotification();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _setupNotificationListener() {
    _notificationSubscription = NotificationService.onNotificationTap.listen((payload) {
      debugPrint('App received notification tap: $payload');
      _handleNotificationPayload(payload);
    });
  }

  void _checkPendingNotification() {
    // Check if app was launched from notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (NotificationService.pendingPayload != null) {
        final payload = NotificationService.pendingPayload!;
        NotificationService.pendingPayload = null;
        debugPrint('App launched from notification with payload: $payload');
        // Delay to allow router to initialize
        Future.delayed(const Duration(milliseconds: 800), () {
          _handleNotificationPayload(payload);
        });
      }
    });
  }

  void _handleNotificationPayload(String payload) {
    debugPrint('Handling notification payload at app level: $payload');
    final router = ref.read(appRouterProvider);

    // Parse payload format: ai_menu_complete:resultId
    if (payload.startsWith('ai_menu_complete')) {
      final parts = payload.split(':');
      if (parts.length >= 2 && parts[1].isNotEmpty) {
        final resultId = parts[1];
        debugPrint('Navigating to AI menu result: $resultId');
        router.go('/admin/menu/ai-result/$resultId');
      } else {
        // Fallback: go to AI creator page where user can see pending results
        debugPrint('No result ID in payload, navigating to AI creator');
        router.go('/admin/menu/ai-creator');
      }
    }
    // Parse payload format: ai_menu_error
    else if (payload.startsWith('ai_menu_error')) {
      // Just go to AI creator page
      router.go('/admin/menu/ai-creator');
    }
    // Parse payload format: ai_image_complete:menuItemId:categoryId
    else if (payload.startsWith('ai_image_complete:')) {
      final parts = payload.split(':');
      if (parts.length >= 3) {
        // Navigate to menu management - the page will handle opening the item
        router.go('/admin/menu');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Routing
      routerConfig: router,
      
      // Localization
      locale: locale,
      supportedLocales: AppConfig.supportedLanguages
          .map((code) => Locale(code))
          .toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

// Keep for backward compatibility if needed
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
