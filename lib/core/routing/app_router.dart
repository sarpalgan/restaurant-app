import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/admin/presentation/pages/admin_shell.dart';
import '../../features/admin/presentation/pages/dashboard_page.dart';
import '../../features/menu/presentation/pages/menu_management_page.dart';
import '../../features/menu/presentation/pages/menu_item_edit_page.dart';
import '../../features/menu/presentation/pages/ai_menu_creator_page.dart';
import '../../features/menu/presentation/pages/ai_menu_result_page.dart';
import '../../features/menu/presentation/pages/saved_menus_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/tables/presentation/pages/tables_page.dart';
import '../../features/customer/presentation/pages/customer_menu_page.dart';
import '../../features/customer/presentation/pages/customer_cart_page.dart';
import '../../features/customer/presentation/pages/customer_order_status_page.dart';

// Route names
class Routes {
  Routes._();
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Admin routes (mobile app)
  static const String adminDashboard = '/admin';
  static const String adminMenu = '/admin/menu';
  static const String adminMenuAdd = '/admin/menu/add';
  static const String adminMenuEdit = '/admin/menu/:itemId';
  static const String adminAiMenuCreator = '/admin/menu/ai-creator';
  static const String adminAiMenuResult = '/admin/menu/ai-result/:resultId';
  static const String adminSavedMenus = '/admin/menu/saved';
  static const String adminOrders = '/admin/orders';
  static const String adminTables = '/admin/tables';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSettings = '/admin/settings';
  static const String adminQrCodes = '/admin/qr-codes';
  static const String adminVideos = '/admin/videos';
  
  // Customer routes (web via QR)
  static const String customerMenu = '/menu/:restaurantSlug/:tableId';
  static const String customerCart = '/menu/:restaurantSlug/:tableId/cart';
  static const String customerOrderStatus = '/menu/:restaurantSlug/:tableId/order/:orderId';
}

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    
    // Redirect logic based on auth state
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;
      final isAuthRoute = state.matchedLocation == Routes.login || 
                          state.matchedLocation == Routes.register;
      final isCustomerRoute = state.matchedLocation.startsWith('/menu/');
      
      // Customer routes don't require authentication
      if (isCustomerRoute) {
        return null;
      }
      
      // If not logged in and trying to access admin, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return Routes.login;
      }
      
      // If logged in and on auth page, redirect to admin
      if (isLoggedIn && isAuthRoute) {
        return Routes.adminDashboard;
      }
      
      return null;
    },
    
    routes: [
      // ============================================================
      // AUTH ROUTES
      // ============================================================
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // ============================================================
      // ADMIN ROUTES (Shell with bottom navigation)
      // ============================================================
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: Routes.adminDashboard,
            name: 'adminDashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: Routes.adminMenu,
            name: 'adminMenu',
            builder: (context, state) => const MenuManagementPage(),
          ),
          GoRoute(
            path: Routes.adminOrders,
            name: 'adminOrders',
            builder: (context, state) => const OrdersPage(),
          ),
          GoRoute(
            path: Routes.adminTables,
            name: 'adminTables',
            builder: (context, state) => const TablesPage(),
          ),
          GoRoute(
            path: Routes.adminAnalytics,
            name: 'adminAnalytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
        ],
      ),
      
      // Admin routes outside shell (full screen)
      GoRoute(
        path: Routes.adminSettings,
        name: 'adminSettings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: Routes.adminAiMenuCreator,
        name: 'adminAiMenuCreator',
        builder: (context, state) => const AIMenuCreatorPage(),
      ),
      GoRoute(
        path: '/admin/menu/ai-result/:resultId',
        name: 'adminAiMenuResult',
        builder: (context, state) {
          final resultId = state.pathParameters['resultId']!;
          return AIMenuResultPage(resultId: resultId);
        },
      ),
      GoRoute(
        path: Routes.adminSavedMenus,
        name: 'adminSavedMenus',
        builder: (context, state) => const SavedMenusPage(),
      ),
      GoRoute(
        path: Routes.adminMenuAdd,
        name: 'adminMenuAdd',
        builder: (context, state) => const MenuItemEditPage(),
      ),
      GoRoute(
        path: '/admin/menu/:itemId',
        name: 'adminMenuEdit',
        builder: (context, state) {
          final itemId = state.pathParameters['itemId'];
          return MenuItemEditPage(itemId: itemId);
        },
      ),
      
      // ============================================================
      // CUSTOMER ROUTES (Web via QR code)
      // ============================================================
      GoRoute(
        path: Routes.customerMenu,
        name: 'customerMenu',
        builder: (context, state) {
          final restaurantSlug = state.pathParameters['restaurantSlug']!;
          final tableId = state.pathParameters['tableId']!;
          return CustomerMenuPage(
            restaurantSlug: restaurantSlug,
            tableId: tableId,
          );
        },
      ),
      GoRoute(
        path: '/menu/:restaurantSlug/:tableId/cart',
        name: 'customerCart',
        builder: (context, state) {
          final restaurantSlug = state.pathParameters['restaurantSlug']!;
          final tableId = state.pathParameters['tableId']!;
          return CustomerCartPage(
            restaurantSlug: restaurantSlug,
            tableId: tableId,
          );
        },
      ),
      GoRoute(
        path: '/menu/:restaurantSlug/:tableId/order/:orderId',
        name: 'customerOrderStatus',
        builder: (context, state) {
          final restaurantSlug = state.pathParameters['restaurantSlug']!;
          final tableId = state.pathParameters['tableId']!;
          final orderId = state.pathParameters['orderId']!;
          return CustomerOrderStatusPage(
            restaurantSlug: restaurantSlug,
            tableId: tableId,
            orderId: orderId,
          );
        },
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? 'Unknown error'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.login),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
