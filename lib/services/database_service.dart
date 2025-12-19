import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class DatabaseService {
  static Database? _database;
  static bool _isWebPlatform = kIsWeb;
  static const String _ordersKey = 'saved_orders';

  Future<Database?> get database async {
    // On web, sqflite doesn't work, so return null
    if (_isWebPlatform) {
      debugPrint('Running on web - using SharedPreferences instead');
      return null;
    }

    if (_database != null) {
      debugPrint('Reusing existing database instance');
      return _database!;
    }

    debugPrint('Initializing new database instance');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get proper persistent path for the database
    String dbPath;

    try {
      // Try to get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      dbPath = join(directory.path, 'sandwich_shop.db');
      debugPrint('✓ Database path: $dbPath');
    } catch (e) {
      // Fallback to in-memory for tests
      debugPrint('⚠ Using in-memory database due to error: $e');
      dbPath = inMemoryDatabasePath;
    }

    try {
      final db = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            debugPrint('Creating orders table...');
            await db.execute('''
              CREATE TABLE orders(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                orderId TEXT NOT NULL,
                totalAmount REAL NOT NULL,
                itemCount INTEGER NOT NULL,
                orderDate INTEGER NOT NULL
              )
            ''');
            debugPrint('✓ Orders table created successfully');
          },
        ),
      );
      debugPrint('✓ Database opened successfully');
      return db;
    } catch (e) {
      debugPrint('✗ Database initialization failed: $e');
      rethrow;
    }
  }

  Future<void> insertOrder(SavedOrder order) async {
    try {
      debugPrint('Attempting to insert order: ${order.orderId}');

      if (_isWebPlatform) {
        // Use SharedPreferences for web
        final prefs = await SharedPreferences.getInstance();
        final ordersJson = prefs.getString(_ordersKey) ?? '[]';
        final List<dynamic> ordersList = jsonDecode(ordersJson);

        // Add new order
        ordersList.add(order.toJson());

        // Save back
        await prefs.setString(_ordersKey, jsonEncode(ordersList));
        debugPrint(
            '✓ Order saved to SharedPreferences (web): ${order.orderId}');
        return;
      }

      final Database? db = await database;
      if (db == null) {
        debugPrint('⚠ Cannot insert order - database is null');
        return;
      }

      final result = await db.insert('orders', order.toMap());
      debugPrint(
          '✓ Order inserted successfully with id: $result, orderId: ${order.orderId}');
    } catch (e) {
      debugPrint('✗ Failed to insert order: $e');
      rethrow;
    }
  }

  Future<List<SavedOrder>> getOrders() async {
    try {
      debugPrint('Attempting to retrieve orders from database...');

      if (_isWebPlatform) {
        // Use SharedPreferences for web
        final prefs = await SharedPreferences.getInstance();
        final ordersJson = prefs.getString(_ordersKey) ?? '[]';
        final List<dynamic> ordersList = jsonDecode(ordersJson);

        debugPrint(
            '✓ Retrieved ${ordersList.length} orders from SharedPreferences (web)');

        List<SavedOrder> orders = [];
        for (var orderJson in ordersList) {
          orders.add(SavedOrder.fromJson(orderJson as Map<String, dynamic>));
        }

        // Sort by date descending
        orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

        if (orders.isEmpty) {
          debugPrint('SharedPreferences is empty - no orders found');
        } else {
          debugPrint('Order IDs: ${orders.map((o) => o.orderId).join(', ')}');
        }

        return orders;
      }

      final Database? db = await database;
      if (db == null) {
        debugPrint('⚠ Cannot retrieve orders - database is null');
        return [];
      }

      final List<Map<String, Object?>> maps = await db.query(
        'orders',
        orderBy: 'orderDate DESC',
      );

      debugPrint('✓ Retrieved ${maps.length} order records from database');

      if (maps.isEmpty) {
        debugPrint('Database is empty - no orders found');
      } else {
        debugPrint('Order IDs: ${maps.map((m) => m['orderId']).join(', ')}');
      }

      List<SavedOrder> orders = [];
      for (int i = 0; i < maps.length; i++) {
        orders.add(SavedOrder.fromMap(maps[i]));
      }
      return orders;
    } catch (e) {
      debugPrint('✗ Failed to retrieve orders: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    final Database? db = await database;
    if (db == null) return; // Skip on web
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
