import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for analytics data and reporting
class AnalyticsService {
  final SupabaseClient _supabase;

  AnalyticsService(this._supabase);

  /// Track a customer event (called from customer web interface)
  Future<void> trackEvent({
    required String restaurantId,
    required String eventType,
    String? branchId,
    String? sessionId,
    String? tableId,
    String? itemId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('analytics_events').insert({
        'restaurant_id': restaurantId,
        'branch_id': branchId,
        'session_id': sessionId,
        'table_id': tableId,
        'event_type': eventType,
        'item_id': itemId,
        'metadata': metadata ?? {},
      });
    } catch (e) {
      debugPrint('Error tracking event: $e');
      // Don't rethrow - analytics errors shouldn't break the app
    }
  }

  /// Get dashboard summary for today
  Future<DashboardSummary> getDashboardSummary(String restaurantId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    try {
      // Get today's orders
      final ordersResult = await _supabase
          .from('orders')
          .select('id, total, status')
          .eq('restaurant_id', restaurantId)
          .gte('created_at', '${today}T00:00:00')
          .lte('created_at', '${today}T23:59:59');

      final orders = List<Map<String, dynamic>>.from(ordersResult);
      final totalOrders = orders.length;
      final totalRevenue = orders.fold<double>(
        0,
        (sum, order) => sum + (double.tryParse(order['total'].toString()) ?? 0),
      );
      final activeOrders = orders.where((o) =>
          o['status'] != 'completed' && o['status'] != 'cancelled').length;

      // Get active tables
      final tablesResult = await _supabase
          .from('tables')
          .select('id, current_session_id')
          .filter('branch_id', 'in', 
            '(SELECT id FROM branches WHERE restaurant_id = \'$restaurantId\')');

      final tables = List<Map<String, dynamic>>.from(tablesResult);
      final activeTables = tables.where(
        (t) => t['current_session_id'] != null,
      ).length;

      // Get menu item count
      final itemsResult = await _supabase
          .from('menu_items')
          .select('id')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true);

      return DashboardSummary(
        totalOrdersToday: totalOrders,
        totalRevenueToday: totalRevenue,
        activeOrders: activeOrders,
        activeTables: activeTables,
        totalTables: tables.length,
        menuItemCount: (itemsResult as List).length,
        averageOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0,
      );
    } catch (e) {
      debugPrint('Error getting dashboard summary: $e');
      return DashboardSummary.empty();
    }
  }

  /// Get sales data for chart
  Future<List<SalesDataPoint>> getSalesData({
    required String restaurantId,
    required DateRange period,
  }) async {
    try {
      final result = await _supabase
          .from('daily_sales_summary')
          .select('date, total_orders, total_revenue')
          .eq('restaurant_id', restaurantId)
          .gte('date', period.start.toIso8601String().split('T')[0])
          .lte('date', period.end.toIso8601String().split('T')[0])
          .order('date');

      return List<Map<String, dynamic>>.from(result).map((row) {
        return SalesDataPoint(
          date: DateTime.parse(row['date']),
          orders: row['total_orders'] as int,
          revenue: double.tryParse(row['total_revenue'].toString()) ?? 0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting sales data: $e');
      return [];
    }
  }

  /// Get top selling items
  Future<List<TopItem>> getTopItems({
    required String restaurantId,
    required DateRange period,
    int limit = 10,
  }) async {
    try {
      // Aggregate from item_performance table
      final result = await _supabase
          .from('item_performance')
          .select('''
            menu_item_id,
            menu_items!inner(id, image_url, menu_item_translations!inner(name, language_code))
          ''')
          .eq('restaurant_id', restaurantId)
          .gte('date', period.start.toIso8601String().split('T')[0])
          .lte('date', period.end.toIso8601String().split('T')[0])
          .order('quantity_sold', ascending: false)
          .limit(limit);

      // Group by item and sum quantities
      final Map<String, TopItem> itemMap = {};
      for (final row in result) {
        final itemId = row['menu_item_id'] as String;
        final item = row['menu_items'];
        final translations = item['menu_item_translations'] as List;
        final englishName = translations.firstWhere(
          (t) => t['language_code'] == 'en',
          orElse: () => translations.first,
        )['name'] as String;

        if (!itemMap.containsKey(itemId)) {
          itemMap[itemId] = TopItem(
            itemId: itemId,
            name: englishName,
            imageUrl: item['image_url'] as String?,
            quantitySold: 0,
            revenue: 0,
          );
        }
      }

      return itemMap.values.toList();
    } catch (e) {
      debugPrint('Error getting top items: $e');
      return [];
    }
  }

  /// Get orders by hour for today
  Future<Map<int, int>> getOrdersByHour(String restaurantId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    try {
      final result = await _supabase
          .from('orders')
          .select('created_at')
          .eq('restaurant_id', restaurantId)
          .gte('created_at', '${today}T00:00:00')
          .lte('created_at', '${today}T23:59:59');

      final Map<int, int> hourlyData = {};
      for (int i = 0; i < 24; i++) {
        hourlyData[i] = 0;
      }

      for (final row in result) {
        final createdAt = DateTime.parse(row['created_at']).toLocal();
        hourlyData[createdAt.hour] = (hourlyData[createdAt.hour] ?? 0) + 1;
      }

      return hourlyData;
    } catch (e) {
      debugPrint('Error getting orders by hour: $e');
      return {};
    }
  }

  /// Get category performance
  Future<List<CategoryPerformance>> getCategoryPerformance({
    required String restaurantId,
    required DateRange period,
  }) async {
    try {
      final result = await _supabase.rpc(
        'get_category_performance',
        params: {
          'p_restaurant_id': restaurantId,
          'p_start_date': period.start.toIso8601String().split('T')[0],
          'p_end_date': period.end.toIso8601String().split('T')[0],
        },
      );

      return List<Map<String, dynamic>>.from(result).map((row) {
        return CategoryPerformance(
          categoryId: row['category_id'] as String,
          categoryName: row['category_name'] as String,
          orderCount: row['order_count'] as int,
          revenue: double.tryParse(row['revenue'].toString()) ?? 0,
          percentage: double.tryParse(row['percentage'].toString()) ?? 0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting category performance: $e');
      return [];
    }
  }
}

/// Dashboard summary data
class DashboardSummary {
  final int totalOrdersToday;
  final double totalRevenueToday;
  final int activeOrders;
  final int activeTables;
  final int totalTables;
  final int menuItemCount;
  final double averageOrderValue;

  DashboardSummary({
    required this.totalOrdersToday,
    required this.totalRevenueToday,
    required this.activeOrders,
    required this.activeTables,
    required this.totalTables,
    required this.menuItemCount,
    required this.averageOrderValue,
  });

  factory DashboardSummary.empty() => DashboardSummary(
        totalOrdersToday: 0,
        totalRevenueToday: 0,
        activeOrders: 0,
        activeTables: 0,
        totalTables: 0,
        menuItemCount: 0,
        averageOrderValue: 0,
      );
}

/// Sales data point for charts
class SalesDataPoint {
  final DateTime date;
  final int orders;
  final double revenue;

  SalesDataPoint({
    required this.date,
    required this.orders,
    required this.revenue,
  });
}

/// Top selling item
class TopItem {
  final String itemId;
  final String name;
  final String? imageUrl;
  final int quantitySold;
  final double revenue;

  TopItem({
    required this.itemId,
    required this.name,
    this.imageUrl,
    required this.quantitySold,
    required this.revenue,
  });
}

/// Category performance
class CategoryPerformance {
  final String categoryId;
  final String categoryName;
  final int orderCount;
  final double revenue;
  final double percentage;

  CategoryPerformance({
    required this.categoryId,
    required this.categoryName,
    required this.orderCount,
    required this.revenue,
    required this.percentage,
  });
}

/// Date range for queries
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});

  factory DateRange.today() {
    final now = DateTime.now();
    return DateRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  factory DateRange.lastWeek() {
    final now = DateTime.now();
    return DateRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  factory DateRange.lastMonth() {
    final now = DateTime.now();
    return DateRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }
}
