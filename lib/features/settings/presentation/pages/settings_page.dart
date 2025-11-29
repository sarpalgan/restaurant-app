import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/language_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);
    final currentLangCode = currentLocale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // App Language - at the very top
          _buildSectionHeader(theme, l10n.language),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  AppConfig.languageFlags[currentLangCode] ?? '🌐',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(AppConfig.languageNames[currentLangCode] ?? 'English'),
            subtitle: Text(l10n.selectLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAppLanguageBottomSheet(context, ref),
          ),
          
          const Divider(),
          
          // Restaurant Profile
          _buildSectionHeader(theme, l10n.profile),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.restaurant, color: theme.primaryColor),
            ),
            title: Text(l10n.restaurant),
            subtitle: Text(l10n.restaurantName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showRestaurantProfile(),
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.store, color: Colors.blue),
            ),
            title: Text(l10n.branches),
            subtitle: Text(l10n.manageRestaurantLocations),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          
          const Divider(),
          
          // Staff & Access
          _buildSectionHeader(theme, l10n.staffAndAccess),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.people, color: Colors.purple),
            ),
            title: Text(l10n.staffMembers),
            subtitle: Text(l10n.manageStaffAccounts),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.security, color: Colors.orange),
            ),
            title: Text(l10n.rolesAndPermissions),
            subtitle: Text(l10n.configureAccessLevels),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          
          const Divider(),
          
          // Orders & Menu
          _buildSectionHeader(theme, l10n.ordersAndMenu),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, color: Colors.teal),
            ),
            title: Text(l10n.orderSettings),
            subtitle: Text(l10n.notificationsConfirmationMode),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showOrderSettings(),
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: Colors.green),
            ),
            title: Text(l10n.menuLanguages),
            subtitle: Text(l10n.languagesEnabled(8)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSettings(),
          ),
          
          const Divider(),
          
          // Payments
          _buildSectionHeader(theme, l10n.payments),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.credit_card, color: Colors.indigo),
            ),
            title: Text(l10n.paymentMethods),
            subtitle: Text(l10n.stripeConnect),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPaymentSettings(),
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.attach_money, color: Colors.amber),
            ),
            title: Text(l10n.subscription),
            subtitle: Text('${l10n.proPlan} - \$79${l10n.perMonth}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.active,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: () => _showSubscriptionDetails(),
          ),
          
          const Divider(),
          
          // Videos
          _buildSectionHeader(theme, l10n.aiVideos),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.video_library, color: Colors.pink),
            ),
            title: Text(l10n.videoCredits),
            subtitle: Text(l10n.pricePerVideo('2.00')),
            trailing: Text(l10n.videosGenerated(23)),
            onTap: () {},
          ),
          
          const Divider(),
          
          // Account
          _buildSectionHeader(theme, l10n.account),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications, color: Colors.grey),
            ),
            title: Text(l10n.notifications),
            subtitle: Text(l10n.pushEmailSms),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.help_outline, color: Colors.grey),
            ),
            title: Text(l10n.help),
            subtitle: Text(l10n.faqContactUs),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.red),
            ),
            title: Text(l10n.signOut, style: const TextStyle(color: Colors.red)),
            onTap: () => _confirmSignOut(),
          ),
          
          const SizedBox(height: 24),
          
          // App version
          Center(
            child: Text(
              'FoodArt v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showRestaurantProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => _RestaurantProfileSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showOrderSettings() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 16),
              Text(
                l10n.orderSettings,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(l10n.requireStaffConfirmation),
                subtitle: Text(l10n.staffMustConfirmOrders),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: Text(l10n.newOrderSound),
                subtitle: Text(l10n.playOrderSound),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: Text(l10n.autoAcceptOrders),
                subtitle: Text(l10n.autoAcceptDescription),
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSettings() {
    final l10n = AppLocalizations.of(context)!;
    final languages = [
      ('English', '🇺🇸', true),
      ('Spanish', '🇪🇸', true),
      ('Italian', '🇮🇹', true),
      ('Turkish', '🇹🇷', true),
      ('Russian', '🇷🇺', true),
      ('Chinese', '🇨🇳', true),
      ('German', '🇩🇪', true),
      ('French', '🇫🇷', true),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.menuLanguages,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.selectMenuLanguages,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...languages.map((lang) => CheckboxListTile(
              title: Row(
                children: [
                  Text(lang.$2, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(lang.$1),
                ],
              ),
              value: lang.$3,
              onChanged: (value) {},
            )).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPaymentSettings() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 16),
              Text(
                l10n.paymentSettings,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.stripeConnected,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l10n.paymentsBeingProcessed,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.platformFee),
                trailing: const Text('2.5%'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.stripeFee),
                trailing: const Text('2.9% + \$0.30'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(l10n.openStripeDashboard),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubscriptionDetails() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 16),
              Text(
                l10n.subscription,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.proPlan,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$79${l10n.perMonth}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.nextBilling('Dec 1, 2024'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${l10n.planFeatures}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem(l10n.upToBranches(5)),
              _buildFeatureItem(l10n.unlimitedMenuItems),
              _buildFeatureItem(l10n.unlimitedOrders),
              _buildFeatureItem(l10n.advancedAnalytics),
              _buildFeatureItem(l10n.prioritySupport),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text(l10n.changePlan),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _confirmSignOut() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Sign out
              context.go('/login');
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

class _RestaurantProfileSheet extends StatelessWidget {
  final ScrollController scrollController;

  const _RestaurantProfileSheet({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 16),
        Text(
          l10n.restaurantProfile,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // Logo
        Center(
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 48,
                  color: theme.primaryColor,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          initialValue: 'My Restaurant',
          decoration: InputDecoration(
            labelText: l10n.restaurantName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'my-restaurant',
          decoration: InputDecoration(
            labelText: l10n.urlSlug,
            border: const OutlineInputBorder(),
            prefixText: 'menu.foodart.com/',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'A wonderful dining experience',
          decoration: InputDecoration(
            labelText: l10n.description,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: '+1 234 567 8900',
          decoration: InputDecoration(
            labelText: l10n.phone,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'contact@myrestaurant.com',
          decoration: InputDecoration(
            labelText: l10n.email,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: '123 Main Street, City',
          decoration: InputDecoration(
            labelText: l10n.address,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileUpdated)),
            );
          },
          child: Text(l10n.saveChanges),
        ),
      ],
    );
  }
}
