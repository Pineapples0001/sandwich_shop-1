import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('CartScreen', () {
    testWidgets('shows empty state and disables checkout when cart empty',
        (tester) async {
      final cart = Cart();
      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(
          find.text('Add sandwiches from the order screen.'), findsOneWidget);
      expect(find.textContaining('Total:'), findsNothing);
      final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
      expect(checkoutButton, findsOneWidget);
      final ElevatedButton btn = tester.widget(checkoutButton);
      expect(btn.onPressed, isNull);
    });

    testWidgets('displays cart items with quantity controls and price',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 2);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.textContaining('£'), findsAtLeastNWidgets(2));
      expect(find.textContaining('Total:'), findsOneWidget);
    });

    testWidgets('increment button increases quantity and updates display',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;
      await tester.tap(addButton);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 2);
      final textField = find.byType(TextFormField).first;
      final TextFormField field = tester.widget(textField);
      expect(field.controller?.text, '2');
    });

    testWidgets('decrement button decreases quantity and updates display',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      cart.updateQuantity(sandwich, 3);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final removeButton = find.widgetWithIcon(IconButton, Icons.remove).first;
      await tester.tap(removeButton);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 2);
      final textField = find.byType(TextFormField).first;
      final TextFormField field = tester.widget(textField);
      expect(field.controller?.text, '2');
    });

    testWidgets('plus button disabled at maximum quantity', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 5);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;
      final IconButton addBtn = tester.widget(addButton);
      expect(addBtn.onPressed, isNull);
    });

    testWidgets('minus button disabled at minimum quantity', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final removeButton = find.widgetWithIcon(IconButton, Icons.remove).first;
      final IconButton removeBtn = tester.widget(removeButton);
      expect(removeBtn.onPressed, isNull);
    });

    testWidgets('direct quantity edit with valid number updates cart',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final quantityField = find.byType(TextFormField).first;
      await tester.enterText(quantityField, '4');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 4);
    });

    testWidgets('direct quantity edit clamps to minimum', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 3);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final quantityField = find.byType(TextFormField).first;
      await tester.enterText(quantityField, '0');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 1);
    });

    testWidgets('direct quantity edit clamps to maximum', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich, 2);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final quantityField = find.byType(TextFormField).first;
      await tester.enterText(quantityField, '10');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 5);
    });

    testWidgets('direct quantity edit with invalid input reverts',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      cart.updateQuantity(sandwich, 3);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final quantityField = find.byType(TextFormField).first;
      await tester.enterText(quantityField, 'abc');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 3);
      final TextFormField field = tester.widget(quantityField);
      expect(field.controller?.text, '3');
    });

    testWidgets('remove button deletes item from cart', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 2);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final deleteButton =
          find.widgetWithIcon(IconButton, Icons.delete_outline).first;
      await tester.tap(deleteButton);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 0);
      expect(cart.isEmpty, true);
    });

    testWidgets('remove shows snackbar with undo action', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich, 3);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final deleteButton =
          find.widgetWithIcon(IconButton, Icons.delete_outline).first;
      await tester.tap(deleteButton);
      await tester.pump();

      expect(find.text('Item removed'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('undo restores removed item with original quantity',
        (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich, 2);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final deleteButton =
          find.widgetWithIcon(IconButton, Icons.delete_outline).first;
      await tester.tap(deleteButton);
      await tester.pump();
      expect(cart.getQuantity(sandwich), 0);

      await tester.pump(const Duration(seconds: 1));
      final undoAction = find.byType(SnackBarAction);
      expect(undoAction, findsOneWidget);
      await tester.tap(undoAction, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(cart.getQuantity(sandwich), 2);
    });

    testWidgets('price updates when quantity changes', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final initialPrice = find.textContaining('£').first;
      expect(initialPrice, findsOneWidget);

      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;
      await tester.tap(addButton);
      await tester.pump();

      expect(cart.getQuantity(sandwich), 2);
      expect(find.textContaining('£'), findsAtLeastNWidgets(2));
    });

    testWidgets('cart total updates reactively', (tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      final sandwich2 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich1, 1);
      cart.updateQuantity(sandwich2, 2);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      expect(find.textContaining('Total:'), findsOneWidget);

      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;
      await tester.tap(addButton);
      await tester.pump();

      expect(find.textContaining('Total:'), findsOneWidget);
      expect(cart.countOfItems, 4);
    });

    testWidgets('multiple items display correctly with separate controls',
        (tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      final sandwich2 = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.updateQuantity(sandwich1, 2);
      cart.updateQuantity(sandwich2, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Tuna Melt'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.add), findsNWidgets(2));
      expect(find.byIcon(Icons.remove), findsNWidgets(2));
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
    });

    testWidgets('checkout button enabled when cart has items', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
      expect(checkoutButton, findsOneWidget);
      final ElevatedButton btn = tester.widget(checkoutButton);
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('back button navigates correctly', (tester) async {
      final cart = Cart();
      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final backButton = find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButton, findsOneWidget);
      final ElevatedButton btn = tester.widget(backButton);
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('trash icon has tooltip', (tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.updateQuantity(sandwich, 1);

      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: cart, maxQuantity: 5)));

      final deleteButton =
          find.widgetWithIcon(IconButton, Icons.delete_outline).first;
      final IconButton btn = tester.widget(deleteButton);
      expect(btn.tooltip, 'Remove item');
    });
  });
}
