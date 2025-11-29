import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'l10n/app_localizations.dart';
import 'services/language_service.dart';

class FoodArtApp extends ConsumerWidget {
  const FoodArtApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
