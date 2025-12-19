# Firebase Integration Guide

## Overview

This sandwich shop app now includes JSON serialization and Firebase Realtime Database integration to save and sync orders across devices.

## Setup

### 1. JSON Serialization

The following models now support JSON serialization:

- `Sandwich` - with `fromJson()` and `toJson()` methods
- `SavedOrder` - with `fromJson()` and `toJson()` methods

Generated files (created by build_runner):

- `lib/models/sandwich.g.dart`
- `lib/models/saved_order.g.dart`

### 2. Firebase Configuration

**Important:** You need to replace the placeholder Firebase credentials in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',              // Replace with your Firebase API key
    appId: 'YOUR_APP_ID',                // Replace with your Firebase App ID
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',  // Replace with your Messaging Sender ID
    projectId: 'YOUR_PROJECT_ID',        // Replace with your Firebase Project ID
    databaseURL: 'YOUR_DATABASE_URL',    // Replace with your Firebase Database URL
  ),
);
```

### 3. Getting Firebase Credentials

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Click on "Add app" and select your platform (Web, Android, iOS)
4. Follow the setup instructions to get your Firebase configuration
5. Enable **Realtime Database** in the Firebase Console:
   - Go to Build → Realtime Database
   - Click "Create Database"
   - Choose a location and security rules

### 4. Regenerating Serialization Code

If you modify the models, regenerate the serialization code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or run in watch mode (auto-regenerates on file changes):

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Firebase Order Service

### Available Methods

#### Save an Order

```dart
final FirebaseOrderService firebaseService = FirebaseOrderService();
await firebaseService.saveOrder(cart, orderId);
```

#### Get All Orders (Stream)

```dart
Stream<DatabaseEvent> ordersStream = firebaseService.getOrders();
```

#### Get Orders as List

```dart
List<Map<String, dynamic>> orders = await firebaseService.getOrdersList();
```

#### Get Specific Order

```dart
Map<String, dynamic>? order = await firebaseService.getOrder(firebaseKey);
```

#### Delete an Order

```dart
await firebaseService.deleteOrder(firebaseKey);
```

## Data Structure

### Order Data in Firebase

```json
{
  "orders": {
    "-firebaseKey123": {
      "orderId": "ORD1234567890",
      "items": [
        {
          "sandwich": {
            "type": "veggieDelight",
            "isFootlong": true,
            "breadType": "wheat"
          },
          "quantity": 2
        }
      ],
      "totalAmount": 22.0,
      "itemCount": 2,
      "orderDate": 1234567890000
    }
  }
}
```

## Integration Points

### Checkout Screen

Orders are automatically saved to both:

1. Local SQLite database (for offline access)
2. Firebase Realtime Database (for cloud sync)

Location: `lib/views/checkout_screen.dart`

### Example Usage

```dart
// In your checkout or order processing code:
final FirebaseOrderService firebaseService = FirebaseOrderService();

try {
  String firebaseKey = await firebaseService.saveOrder(cart, orderId);
  print('Order saved to Firebase with key: $firebaseKey');
} catch (e) {
  print('Error saving to Firebase: $e');
}
```

### Displaying Firebase Orders

```dart
// Get orders list
final orders = await firebaseService.getOrdersList();

// Display in a ListView
ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index];
    return ListTile(
      title: Text('Order: ${order['orderId']}'),
      subtitle: Text('£${order['totalAmount']} - ${order['itemCount']} items'),
      trailing: Text(
        DateTime.fromMillisecondsSinceEpoch(order['orderDate']).toString()
      ),
    );
  },
);
```

## Security Rules

**Important:** Update your Firebase Realtime Database rules for production:

### Development (Open Access)

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### Production (Authenticated Users Only)

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

## Troubleshooting

### Build Runner Issues

- Make sure all models have proper imports
- Check for syntax errors in model files
- Delete generated files manually and rebuild if needed

### Firebase Connection Issues

- Verify Firebase credentials are correct
- Check internet connectivity
- Ensure Firebase Database is created in the console
- Review Firebase Database security rules

### JSON Serialization Issues

- Ensure all nested objects also have JSON serialization
- Check for circular references in models
- Verify enum handling is correct

## Dependencies Added

```yaml
dependencies:
  json_annotation: latest
  firebase_core: latest
  firebase_database: latest

dev_dependencies:
  build_runner: latest
  json_serializable: latest
```
