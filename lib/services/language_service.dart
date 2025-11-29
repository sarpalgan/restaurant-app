import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';

// App locale provider - controls the app's UI language
final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  return AppLocaleNotifier();
});

class AppLocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';
  
  AppLocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      if (savedLocale != null && AppConfig.supportedLanguages.contains(savedLocale)) {
        state = Locale(savedLocale);
      }
    } catch (e) {
      // Use default 'en' if loading fails
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (!AppConfig.supportedLanguages.contains(languageCode)) return;
    
    state = Locale(languageCode);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      // Continue with in-memory state even if persistence fails
    }
  }

  String get currentLanguageCode => state.languageCode;
  
  String get currentLanguageName => AppConfig.languageNames[state.languageCode] ?? 'English';
  
  String get currentLanguageFlag => AppConfig.languageFlags[state.languageCode] ?? '';
}

// Bottom sheet for app language selection
void showAppLanguageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final currentLocale = ref.watch(appLocaleProvider);
        final currentLangCode = currentLocale.languageCode;
        
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Language',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: AppConfig.supportedLanguages.map((lang) {
                        final isSelected = lang == currentLangCode;
                        return ListTile(
                          leading: Text(
                            AppConfig.languageFlags[lang] ?? '',
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(AppConfig.languageNames[lang] ?? lang),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          selected: isSelected,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () {
                            ref.read(appLocaleProvider.notifier).setLocale(lang);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
