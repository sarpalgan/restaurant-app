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
  
  String get currentLanguageFlag => AppConfig.languageFlags[state.languageCode] ?? '🇬🇧';
}

// Helper extension to get translated text from a translations map
extension TranslationHelper on Map<String, dynamic>? {
  String getTranslated(String languageCode, {String fallback = ''}) {
    if (this == null) return fallback;
    return this![languageCode]?.toString() ?? this!['en']?.toString() ?? fallback;
  }
}

// Language selector widget for settings
class AppLanguageSelector extends ConsumerWidget {
  final bool showLabel;

  const AppLanguageSelector({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);
    final currentLangCode = currentLocale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'App Language',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ...AppConfig.supportedLanguages.map((lang) {
          final isSelected = lang == currentLangCode;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected 
                  ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading: Text(
                AppConfig.languageFlags[lang] ?? '🌐',
                style: const TextStyle(fontSize: 28),
              ),
              title: Text(
                AppConfig.languageNames[lang] ?? lang.toUpperCase(),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
              onTap: () {
                ref.read(appLocaleProvider.notifier).setLocale(lang);
              },
            ),
          );
        }),
      ],
    );
  }
}

// Compact language picker for app bar
class CompactLanguagePicker extends ConsumerWidget {
  const CompactLanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);
    final currentLangCode = currentLocale.languageCode;

    return PopupMenuButton<String>(
      initialValue: currentLangCode,
      onSelected: (value) => ref.read(appLocaleProvider.notifier).setLocale(value),
      tooltip: 'Change Language',
      itemBuilder: (context) => AppConfig.supportedLanguages.map((lang) {
        return PopupMenuItem(
          value: lang,
          child: Row(
            children: [
              Text(AppConfig.languageFlags[lang] ?? '', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text(AppConfig.languageNames[lang] ?? lang)),
              if (lang == currentLangCode)
                const Icon(Icons.check, color: Colors.green, size: 18),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConfig.languageFlags[currentLangCode] ?? '🌐',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}

// Bottom sheet for language selection
void showAppLanguageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final currentLocale = ref.watch(appLocaleProvider);
        final currentLangCode = currentLocale.languageCode;
        
        return SafeArea(
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
                ...AppConfig.supportedLanguages.map((lang) {
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
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ),
  );
}
