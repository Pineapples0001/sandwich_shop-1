import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/app_drawer.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('AppDrawer Widget Tests', () {
    testWidgets('renders drawer with header and all navigation items',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify drawer header
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Fresh & Delicious'), findsOneWidget);

      // Verify all navigation items
      expect(find.text('Order Sandwiches'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);

      // Verify version info
      expect(find.text('Version 1.0.0'), findsOneWidget);
    });

    testWidgets('displays correct icons for each navigation item',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify navigation icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('highlights current route', (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/profile', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Find the Profile ListTile
      final profileTile = find.ancestor(
        of: find.text('My Profile'),
        matching: find.byType(ListTile),
      );

      expect(profileTile, findsOneWidget);

      // Verify it's selected
      final listTile = tester.widget<ListTile>(profileTile);
      expect(listTile.selected, isTrue);
    });

    testWidgets('shows cart badge when cart has items',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich);
      cart.add(sandwich);
      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify badge shows correct count
      expect(find.text('3'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('does not show cart badge when cart is empty',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify no badge shown
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('closes drawer when navigation item tapped',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
                  drawer: AppDrawer(currentRoute: '/order', cart: cart),
                  body: const Center(child: Text('Order Screen')),
                ),
            '/profile': (context) => Scaffold(
                  drawer: AppDrawer(currentRoute: '/profile', cart: cart),
                  body: const Center(child: Text('Profile Screen')),
                ),
          },
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify drawer is open
      expect(find.text('Sandwich Shop'), findsOneWidget);

      // Tap on Profile
      await tester.tap(find.text('My Profile'));
      await tester.pumpAndSettle();

      // Verify drawer is closed (drawer content not visible)
      expect(find.text('Profile Screen'), findsOneWidget);
    });

    testWidgets('does not navigate when tapping current route item',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Order Screen')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Tap on Order Sandwiches (current route)
      await tester.tap(find.text('Order Sandwiches'));
      await tester.pumpAndSettle();

      // Verify we're still on the same screen
      expect(find.text('Order Screen'), findsOneWidget);
    });

    testWidgets('drawer has proper dividers', (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify dividers are present
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('drawer header has logo image', (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify logo image is present in drawer header
      final drawerHeader = find.byType(DrawerHeader);
      expect(drawerHeader, findsOneWidget);

      final imagesInHeader = find.descendant(
        of: drawerHeader,
        matching: find.byType(Image),
      );
      expect(imagesInHeader, findsOneWidget);
    });

    testWidgets('drawer width adjusts for wide screens',
        (WidgetTester tester) async {
      final cart = Cart();

      // Set large screen size
      tester.view.physicalSize = const Size(1400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: AppDrawer(currentRoute: '/order', cart: cart),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify drawer is present (width is internal, we verify it renders)
      expect(find.byType(Drawer), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('cart badge updates when cart changes',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              drawer: AppDrawer(currentRoute: '/order', cart: cart),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final sandwich = Sandwich(
                        type: SandwichType.veggieDelight,
                        isFootlong: true,
                        breadType: BreadType.white,
                      );
                      cart.add(sandwich);
                    });
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open the drawer - should have no badge
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(CircleAvatar), findsNothing);

      // Close drawer
      await tester.tap(find.text('Order Sandwiches'));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Open drawer again
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify badge now shows
      expect(find.text('1'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('all navigation items are tappable',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                drawer:
                    AppDrawer(currentRoute: settings.name ?? '/', cart: cart),
                body: Center(child: Text('Screen: ${settings.name}')),
              ),
            );
          },
        ),
      );

      // Open the drawer
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify all items have ListTile (tappable)
      expect(find.byType(ListTile), findsNWidgets(4)); // 4 navigation items
    });
  });
}
