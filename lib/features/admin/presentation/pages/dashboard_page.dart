import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.adminSettings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeCard(theme, l10n, isSmallScreen),
              const SizedBox(height: 20),
              
              // AI Menu Creator Promo
              _buildAIMenuCreatorPromo(theme, l10n, isSmallScreen),
              const SizedBox(height: 20),
              
              // Quick Stats
              Text(
                l10n.todaysOverview,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : null,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatsGrid(theme, l10n, isSmallScreen),
              const SizedBox(height: 20),
              
              // Quick Actions
              Text(
                l10n.quickActions,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : null,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(theme, l10n, isSmallScreen),
              const SizedBox(height: 20),
              
              // Recent Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.recentOrders,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 18 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(Routes.adminOrders),
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRecentOrders(theme, l10n, isSmallScreen),
              const SizedBox(height: 20),
              
              // AI Insights
              Text(
                l10n.aiInsights,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : null,
                ),
              ),
              const SizedBox(height: 12),
              _buildAIInsights(theme, l10n, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIMenuCreatorPromo(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.newAiMenuCreator,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.createMenuInSeconds,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.uploadMenuDescription,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildPromoFeature(l10n.aiFeature1, isSmallScreen),
          _buildPromoFeature(l10n.aiFeature2, isSmallScreen),
          _buildPromoFeature(l10n.aiFeature3, isSmallScreen),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.adminAiMenuCreator),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, size: isSmallScreen ? 18 : 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.tryAiMenuCreator,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoFeature(String text, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: isSmallScreen ? 12 : 13,
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcomeBack,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dashboardSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: isSmallScreen ? 13 : null,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildWelcomeStatItem(
                icon: Icons.receipt_long,
                value: '12',
                label: l10n.activeOrders,
                isSmallScreen: isSmallScreen,
              ),
              _buildWelcomeStatItem(
                icon: Icons.table_bar,
                value: '8/15',
                label: l10n.tablesOccupied,
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isSmallScreen,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: isSmallScreen ? 18 : 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: isSmallScreen ? 8 : 12,
      crossAxisSpacing: isSmallScreen ? 8 : 12,
      childAspectRatio: isSmallScreen ? 1.3 : 1.5,
      children: [
        _buildStatCard(
          theme: theme,
          icon: Icons.attach_money,
          iconColor: Colors.green,
          title: l10n.revenue,
          value: '\$1,245',
          change: '+12.5%',
          isPositive: true,
          isSmallScreen: isSmallScreen,
        ),
        _buildStatCard(
          theme: theme,
          icon: Icons.shopping_cart,
          iconColor: Colors.blue,
          title: l10n.orders,
          value: '48',
          change: '+8',
          isPositive: true,
          isSmallScreen: isSmallScreen,
        ),
        _buildStatCard(
          theme: theme,
          icon: Icons.people,
          iconColor: Colors.orange,
          title: l10n.customers,
          value: '127',
          change: '-5',
          isPositive: false,
          isSmallScreen: isSmallScreen,
        ),
        _buildStatCard(
          theme: theme,
          icon: Icons.star,
          iconColor: Colors.amber,
          title: l10n.avgRating,
          value: '4.8',
          change: '+0.2',
          isPositive: true,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: isSmallScreen ? 20 : 24),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 20 : null,
                  ),
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: isSmallScreen ? 11 : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            theme: theme,
            icon: Icons.auto_awesome,
            label: l10n.aiMenu,
            color: Colors.purple,
            onTap: () => context.push(Routes.adminAiMenuCreator),
            isSmallScreen: isSmallScreen,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: _buildQuickActionButton(
            theme: theme,
            icon: Icons.add_circle_outline,
            label: l10n.addItem,
            color: theme.primaryColor,
            onTap: () {
              context.push(Routes.adminMenuAdd);
            },
            isSmallScreen: isSmallScreen,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: _buildQuickActionButton(
            theme: theme,
            icon: Icons.qr_code,
            label: l10n.qrCodes,
            color: Colors.teal,
            onTap: () => context.push(Routes.adminQrCodes),
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: isSmallScreen ? 24 : 28),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallScreen ? 11 : 13,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    // Mock data - will be replaced with real data
    final orders = [
      _OrderItem(
        tableNumber: '${l10n.table} 5',
        items: l10n.itemCount(3),
        total: '\$45.50',
        status: l10n.preparing,
        statusColor: Colors.orange,
      ),
      _OrderItem(
        tableNumber: '${l10n.table} 2',
        items: l10n.itemCount(5),
        total: '\$78.00',
        status: l10n.ready,
        statusColor: Colors.green,
      ),
      _OrderItem(
        tableNumber: '${l10n.table} 8',
        items: l10n.itemCount(2),
        total: '\$24.00',
        status: l10n.newStatus,
        statusColor: Colors.blue,
      ),
    ];

    return Column(
      children: orders.map((order) => _buildOrderItem(theme, order, isSmallScreen)).toList(),
    );
  }

  Widget _buildOrderItem(ThemeData theme, _OrderItem order, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 40 : 48,
            height: isSmallScreen ? 40 : 48,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.table_bar,
              color: theme.primaryColor,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.tableNumber,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 14 : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  order.items,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: isSmallScreen ? 11 : null,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.total,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : null,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: order.statusColor,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights(ThemeData theme, AppLocalizations l10n, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.purple,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.aiRecommendations,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            icon: Icons.trending_up,
            color: Colors.green,
            text: l10n.trendingDish('Grilled Salmon'),
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.access_time,
            color: Colors.orange,
            text: l10n.peakHours('12PM-2PM'),
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.video_library,
            color: Colors.blue,
            text: l10n.noVideosHint(5),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required Color color,
    required String text,
    required bool isSmallScreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: isSmallScreen ? 18 : 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          ),
        ),
      ],
    );
  }
}

class _OrderItem {
  final String tableNumber;
  final String items;
  final String total;
  final String status;
  final Color statusColor;

  _OrderItem({
    required this.tableNumber,
    required this.items,
    required this.total,
    required this.status,
    required this.statusColor,
  });
}
