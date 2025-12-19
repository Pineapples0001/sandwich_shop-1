import 'package:firebase_database/firebase_database.dart';
import 'package:sandwich_shop/models/cart.dart';

class FirebaseOrderService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Save a new order to Firebase
  Future<String> saveOrder(Cart cart, String orderId) async {
    try {
      // Convert cart items to a serializable format
      final List<Map<String, dynamic>> items = [];

      for (final entry in cart.items.entries) {
        final sandwich = entry.key;
        final quantity = entry.value;

        items.add({
          'sandwich': sandwich.toJson(),
          'quantity': quantity,
        });
      }

      final orderData = {
        'orderId': orderId,
        'items': items,
        'totalAmount': cart.totalPrice,
        'itemCount': cart.countOfItems,
        'orderDate': DateTime.now().millisecondsSinceEpoch,
      };

      // Push the order to Firebase
      final orderRef = await _database.child('orders').push();
      await orderRef.set(orderData);

      return orderRef.key ?? orderId;
    } catch (e) {
      throw Exception('Error saving order: $e');
    }
  }

  /// Get all orders from Firebase
  Stream<DatabaseEvent> getOrders() {
    return _database.child('orders').onValue;
  }

  /// Get a specific order by Firebase key
  Future<Map<String, dynamic>?> getOrder(String firebaseKey) async {
    try {
      final snapshot = await _database.child('orders/$firebaseKey').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  /// Delete an order from Firebase
  Future<void> deleteOrder(String firebaseKey) async {
    try {
      await _database.child('orders/$firebaseKey').remove();
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  /// Get orders as a list (useful for displaying in UI)
  Future<List<Map<String, dynamic>>> getOrdersList() async {
    try {
      final snapshot = await _database.child('orders').get();
      if (snapshot.exists) {
        final ordersMap = Map<String, dynamic>.from(snapshot.value as Map);
        final List<Map<String, dynamic>> ordersList = [];

        ordersMap.forEach((key, value) {
          final orderData = Map<String, dynamic>.from(value as Map);
          orderData['firebaseKey'] = key; // Add the Firebase key for reference
          ordersList.add(orderData);
        });

        // Sort by date (newest first)
        ordersList.sort(
            (a, b) => (b['orderDate'] as int).compareTo(a['orderDate'] as int));

        return ordersList;
      }
      return [];
    } catch (e) {
      throw Exception('Error fetching orders list: $e');
    }
  }
}
