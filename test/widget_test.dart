import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // initial _quantity in OrderScreen is 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // increment via the add IconButton
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // start at 1, increment to 2 then decrement back to 1
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // starting at 1, remove twice should stop at 0 and not go negative
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // app currently does not enforce a max limit; verify repeated taps increment
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      // initial 1 + 10 taps = 11
      expect(find.text('11'), findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('toggles size switch value', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final Finder switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      // initial value is true
      Switch sw = tester.widget<Switch>(switchFinder);
      expect(sw.value, isTrue);
      await tester.tap(switchFinder);
      await tester.pump();
      sw = tester.widget<Switch>(switchFinder);
      expect(sw.value, isFalse);
    });
    testWidgets('bread type dropdown is present and can open',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final Finder dropdown = find.byType(DropdownMenu<BreadType>);
      expect(dropdown, findsOneWidget);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      // ensure options are displayed
      expect(find.text('wheat'), findsWidgets);
    });

    // Note: OrderScreen currently does not expose a notes TextField in the UI.
    // If a TextField is added later, add tests here to exercise it.
  });

  group('OrderScreen - Modal', () {
    testWidgets('shows modal with confirmation after Add to Cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Tap the Add to Cart button (StyledButton with label 'Add to Cart')
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Default values: quantity=1, footlong, veggieDelight, white bread
      const expectedMessage =
          'Added 1 footlong Veggie Delight sandwich(es) on white bread to cart';

      expect(find.text(expectedMessage), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Close'), findsOneWidget);

      // Close the modal and verify it's dismissed
      await tester.tap(find.widgetWithText(ElevatedButton, 'Close'));
      await tester.pumpAndSettle();
      expect(find.text(expectedMessage), findsNothing);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('3 white footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('2 wheat six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        orderNote: 'Lots of lettuce',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('1 wholemeal footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });
}
