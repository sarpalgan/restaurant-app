import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'today', child: Text('Today')),
              const PopupMenuItem(value: 'week', child: Text('This Week')),
              const PopupMenuItem(value: 'month', child: Text('This Month')),
              const PopupMenuItem(value: 'year', child: Text('This Year')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_getPeriodLabel()),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              _buildSummaryCards(theme),
              const SizedBox(height: 24),
              
              // Revenue Chart
              _buildSectionTitle(theme, 'Revenue'),
              const SizedBox(height: 12),
              _buildRevenueChart(theme),
              const SizedBox(height: 24),
              
              // Popular Items
              _buildSectionTitle(theme, 'Top Selling Items'),
              const SizedBox(height: 12),
              _buildPopularItems(theme),
              const SizedBox(height: 24),
              
              // Order Distribution
              _buildSectionTitle(theme, 'Orders by Time'),
              const SizedBox(height: 12),
              _buildOrderDistribution(theme),
              const SizedBox(height: 24),
              
              // AI Recommendations
              _buildSectionTitle(theme, 'AI Recommendations'),
              const SizedBox(height: 12),
              _buildAIRecommendations(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case 'today':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'This Week';
    }
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          theme: theme,
          title: 'Total Revenue',
          value: '\$8,547.00',
          change: '+18.2%',
          isPositive: true,
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _buildSummaryCard(
          theme: theme,
          title: 'Total Orders',
          value: '324',
          change: '+12',
          isPositive: true,
          icon: Icons.receipt_long,
          color: Colors.blue,
        ),
        _buildSummaryCard(
          theme: theme,
          title: 'Avg Order Value',
          value: '\$26.38',
          change: '+\$2.45',
          isPositive: true,
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
        _buildSummaryCard(
          theme: theme,
          title: 'Customers',
          value: '287',
          change: '-5',
          isPositive: false,
          icon: Icons.people,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required ThemeData theme,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(ThemeData theme) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
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
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 500,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 2000,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1200),
                FlSpot(1, 1400),
                FlSpot(2, 1100),
                FlSpot(3, 1600),
                FlSpot(4, 1450),
                FlSpot(5, 1800),
                FlSpot(6, 1547),
              ],
              isCurved: true,
              color: theme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: theme.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItems(ThemeData theme) {
    final items = [
      _PopularItem(name: 'Grilled Salmon', orders: 87, revenue: 2174.13),
      _PopularItem(name: 'Margherita Pizza', orders: 72, revenue: 1367.28),
      _PopularItem(name: 'Caesar Salad', orders: 65, revenue: 844.35),
      _PopularItem(name: 'Beef Steak', orders: 54, revenue: 1781.46),
      _PopularItem(name: 'Tiramisu', orders: 48, revenue: 431.52),
    ];

    return Container(
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
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final maxOrders = items.first.orders;
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: index < items.length - 1
                  ? Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getRankColor(index).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _getRankColor(index),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: item.orders / maxOrders,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.orders} orders',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${item.revenue.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOrderDistribution(ThemeData theme) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final hours = ['10AM', '11AM', '12PM', '1PM', '2PM', '3PM', 
                              '4PM', '5PM', '6PM', '7PM', '8PM', '9PM'];
                return BarTooltipItem(
                  '${hours[groupIndex]}\n${rod.toY.toInt()} orders',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const hours = ['10', '11', '12', '1', '2', '3', 
                                '4', '5', '6', '7', '8', '9'];
                  if (value.toInt() >= 0 && value.toInt() < hours.length) {
                    return Text(
                      hours[value.toInt()],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: [
            _makeBarGroup(0, 12, theme),
            _makeBarGroup(1, 18, theme),
            _makeBarGroup(2, 42, theme),
            _makeBarGroup(3, 38, theme),
            _makeBarGroup(4, 25, theme),
            _makeBarGroup(5, 15, theme),
            _makeBarGroup(6, 20, theme),
            _makeBarGroup(7, 35, theme),
            _makeBarGroup(8, 45, theme),
            _makeBarGroup(9, 40, theme),
            _makeBarGroup(10, 28, theme),
            _makeBarGroup(11, 15, theme),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, ThemeData theme) {
    final isPeak = y >= 35;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isPeak ? theme.primaryColor : theme.primaryColor.withOpacity(0.5),
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildAIRecommendations(ThemeData theme) {
    final recommendations = [
      _Recommendation(
        icon: Icons.trending_up,
        color: Colors.green,
        title: 'Increase Salmon Pricing',
        description: 'Grilled Salmon has high demand. Consider a 5-10% price increase.',
        impact: 'Potential +\$217/week',
      ),
      _Recommendation(
        icon: Icons.schedule,
        color: Colors.orange,
        title: 'Optimize Lunch Staffing',
        description: 'Peak orders at 12PM-1PM. Add 1 more staff during this period.',
        impact: 'Reduce wait time by 15%',
      ),
      _Recommendation(
        icon: Icons.video_library,
        color: Colors.blue,
        title: 'Add Videos to Top Items',
        description: '3 of your top 5 items don\'t have videos. Items with videos get 25% more orders.',
        impact: 'Potential +45 orders/week',
      ),
      _Recommendation(
        icon: Icons.category,
        color: Colors.purple,
        title: 'Promote Desserts',
        description: 'Dessert orders are low. Consider a "dessert with meal" combo offer.',
        impact: 'Increase dessert sales 30%',
      ),
    ];

    return Column(
      children: recommendations.map((rec) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rec.color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: rec.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(rec.icon, color: rec.color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rec.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: rec.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      rec.impact,
                      style: TextStyle(
                        color: rec.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _PopularItem {
  final String name;
  final int orders;
  final double revenue;

  _PopularItem({
    required this.name,
    required this.orders,
    required this.revenue,
  });
}

class _Recommendation {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String impact;

  _Recommendation({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.impact,
  });
}
