import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

void main() {
  group('CheckoutScreen', () {
    testWidgets('displays order summary with cart items', (tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      final sandwich2 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.add(sandwich1, quantity: 2);
      cart.add(sandwich2, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('1x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('displays correct total price', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      cart.add(sandwich, quantity: 3);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.textContaining('Total:'), findsOneWidget);
      expect(find.textContaining('£'), findsAtLeastNWidgets(2));
    });

    testWidgets('displays payment method information', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white);
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
    });

    testWidgets('displays confirm payment button initially', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows processing indicator when payment is processing',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white);
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      final confirmButton = find.text('Confirm Payment');
      await tester.tap(confirmButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsNothing);
    });

    testWidgets('returns order confirmation after processing', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.add(sandwich, quantity: 1);

      Map? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckoutScreen(cart: cart)),
              );
            },
            child: const Text('Go to Checkout'),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Payment'), findsOneWidget);

      await tester.tap(find.text('Confirm Payment'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result?['orderId'], isNotNull);
      expect(result?['totalAmount'], equals(cart.totalPrice));
      expect(result?['itemCount'], equals(cart.countOfItems));
      expect(result?['estimatedTime'], equals('15-20 minutes'));
    });

    testWidgets('displays divider between items and total', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white);
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('displays all items with quantities and prices',
        (tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      final sandwich2 = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.wheat);
      final sandwich3 = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 2);
      cart.add(sandwich3, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('2x Meatball Marinara'), findsOneWidget);
      expect(find.text('1x Tuna Melt'), findsOneWidget);
      expect(find.textContaining('£'), findsAtLeastNWidgets(4));
    });

    testWidgets('has correct app bar title', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.white);
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('order ID format is correct', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.add(sandwich, quantity: 1);

      Map? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckoutScreen(cart: cart)),
              );
            },
            child: const Text('Go to Checkout'),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Payment'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(result?['orderId'], startsWith('ORD'));
      expect(result?['orderId'].toString().length, greaterThan(3));
    });

    testWidgets('empty cart still shows checkout screen', (tester) async {
      final cart = Cart();

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);
    });
  });
}
