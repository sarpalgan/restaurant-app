import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({super.key});

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  final List<_Table> _tables = List.generate(
    15,
    (index) => _Table(
      id: 'table_${index + 1}',
      number: index + 1,
      capacity: (index % 3 + 2) * 2,
      isOccupied: index % 3 == 0,
      currentSession: index % 3 == 0 ? 'Session ${index + 100}' : null,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    // Adaptive grid columns based on screen width
    final crossAxisCount = screenWidth < 320 ? 2 : (screenWidth < 500 ? 3 : 4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'Download All QR Codes',
            onPressed: _downloadAllQrCodes,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Table',
            onPressed: _showAddTableDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            color: theme.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildSummaryItem(
                    theme,
                    icon: Icons.table_bar,
                    value: '${_tables.length}',
                    label: 'Total',
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                Flexible(
                  child: _buildSummaryItem(
                    theme,
                    icon: Icons.check_circle,
                    value: '${_tables.where((t) => !t.isOccupied).length}',
                    label: 'Available',
                    color: Colors.green,
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                Flexible(
                  child: _buildSummaryItem(
                    theme,
                    icon: Icons.people,
                    value: '${_tables.where((t) => t.isOccupied).length}',
                    label: 'Occupied',
                    color: Colors.orange,
                    isSmallScreen: isSmallScreen,
                  ),
                ),
              ],
            ),
          ),
          
          // Tables grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: isSmallScreen ? 8 : 12,
                crossAxisSpacing: isSmallScreen ? 8 : 12,
                childAspectRatio: 0.9,
              ),
              itemCount: _tables.length,
              itemBuilder: (context, index) => _buildTableCard(theme, _tables[index], isSmallScreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    ThemeData theme, {
    required IconData icon,
    required String value,
    required String label,
    Color? color,
    required bool isSmallScreen,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color ?? theme.primaryColor, size: isSmallScreen ? 16 : 20),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? theme.primaryColor,
                fontSize: isSmallScreen ? 18 : null,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
            fontSize: isSmallScreen ? 10 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTableCard(ThemeData theme, _Table table, bool isSmallScreen) {
    return InkWell(
      onTap: () => _showTableOptions(table),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
        decoration: BoxDecoration(
          color: table.isOccupied 
              ? Colors.orange.withOpacity(0.1) 
              : Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: table.isOccupied 
                ? Colors.orange.withOpacity(0.3) 
                : Colors.green.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_bar,
              size: isSmallScreen ? 24 : 32,
              color: table.isOccupied ? Colors.orange : Colors.green,
            ),
            SizedBox(height: isSmallScreen ? 4 : 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Table ${table.number}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 13 : null,
                ),
              ),
            ),
            Text(
              '${table.capacity} seats',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: isSmallScreen ? 10 : null,
              ),
            ),
            if (table.isOccupied) ...[
              SizedBox(height: isSmallScreen ? 2 : 4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : 6, 
                  vertical: isSmallScreen ? 1 : 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'OCCUPIED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 8 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showTableOptions(_Table table) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Table ${table.number}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('View QR Code'),
              onTap: () {
                Navigator.pop(context);
                _showQrCode(table);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download QR Code'),
              onTap: () {
                Navigator.pop(context);
                _downloadQrCode(table);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Menu Link'),
              onTap: () {
                Navigator.pop(context);
                _copyMenuLink(table);
              },
            ),
            if (table.isOccupied)
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('View Current Session'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to session
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Table'),
              onTap: () {
                Navigator.pop(context);
                _showEditTableDialog(table);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Table', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTable(table);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showQrCode(_Table table) {
    final menuUrl = 'https://menu.foodart.com/restaurant-slug/table-${table.number}';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.number} QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: QrImageView(
                data: menuUrl,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Theme.of(context).primaryColor,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Scan to view menu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              menuUrl,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _downloadQrCode(table);
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _downloadQrCode(_Table table) {
    // TODO: Implement QR code download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR code for Table ${table.number} downloaded'),
      ),
    );
  }

  void _downloadAllQrCodes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download All QR Codes'),
        content: const Text(
          'Download QR codes for all tables as a PDF file for printing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Generate and download PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR codes PDF downloaded'),
                ),
              );
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }

  void _copyMenuLink(_Table table) {
    final menuUrl = 'https://menu.foodart.com/restaurant-slug/table-${table.number}';
    Clipboard.setData(ClipboardData(text: menuUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menu link copied to clipboard'),
      ),
    );
  }

  void _showAddTableDialog() {
    final numberController = TextEditingController();
    final capacityController = TextEditingController(text: '4');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Table Number',
                hintText: 'e.g., 16',
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacity (seats)',
                hintText: 'e.g., 4',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Add table
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Table added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTableDialog(_Table table) {
    final numberController = TextEditingController(text: '${table.number}');
    final capacityController = TextEditingController(text: '${table.capacity}');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Table ${table.number}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Table Number',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacity (seats)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Update table
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Table updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTable(_Table table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Table'),
        content: Text(
          'Are you sure you want to delete Table ${table.number}? '
          'This will also delete all associated QR codes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete table
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Table ${table.number} deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _Table {
  final String id;
  final int number;
  final int capacity;
  final bool isOccupied;
  final String? currentSession;

  _Table({
    required this.id,
    required this.number,
    required this.capacity,
    required this.isOccupied,
    this.currentSession,
  });
}
