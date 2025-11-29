import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';

class AdminShell extends ConsumerStatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _currentIndex = 0;
  final List<int> _navigationHistory = [0]; // Track tab navigation history
  DateTime? _lastBackPressTime;

  List<_NavItem> _getNavItems(AppLocalizations l10n) => [
    _NavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: l10n.dashboard,
      route: Routes.adminDashboard,
    ),
    _NavItem(
      icon: Icons.restaurant_menu_outlined,
      activeIcon: Icons.restaurant_menu,
      label: l10n.menu,
      route: Routes.adminMenu,
    ),
    _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: l10n.orders,
      route: Routes.adminOrders,
    ),
    _NavItem(
      icon: Icons.table_bar_outlined,
      activeIcon: Icons.table_bar,
      label: l10n.tables,
      route: Routes.adminTables,
    ),
    _NavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: l10n.analytics,
      route: Routes.adminAnalytics,
    ),
  ];

  // Route list for index lookup (doesn't need localization)
  final List<String> _routes = [
    Routes.adminDashboard,
    Routes.adminMenu,
    Routes.adminOrders,
    Routes.adminTables,
    Routes.adminAnalytics,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexWhere((route) => route == location);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      // Add current index to history before navigating
      if (_navigationHistory.isEmpty || _navigationHistory.last != _currentIndex) {
        _navigationHistory.add(_currentIndex);
      }
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  Future<bool> _onWillPop() async {
    // If we have navigation history, go back to previous tab
    if (_navigationHistory.length > 1) {
      _navigationHistory.removeLast();
      final previousIndex = _navigationHistory.last;
      setState(() => _currentIndex = previousIndex);
      context.go(_routes[previousIndex]);
      return false;
    }
    
    // If on Dashboard (first tab) with no history, show exit confirmation
    if (_currentIndex == 0) {
      final now = DateTime.now();
      if (_lastBackPressTime == null || 
          now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
        _lastBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      // Exit the app
      SystemNavigator.pop();
      return true;
    }
    
    // If on another tab with no history, go to Dashboard
    _navigationHistory.clear();
    _navigationHistory.add(0);
    setState(() => _currentIndex = 0);
    context.go(_routes[0]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final navItems = _getNavItems(l10n);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: theme.primaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: isSmallScreen ? 10 : 12,
              unselectedFontSize: isSmallScreen ? 10 : 12,
              iconSize: isSmallScreen ? 22 : 24,
              items: navItems
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        activeIcon: Icon(item.activeIcon),
                        label: item.label,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
