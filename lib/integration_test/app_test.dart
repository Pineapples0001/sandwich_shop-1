import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      // Use mainTest instead of main to skip Firebase initialization
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton); // Scroll if needed
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Scroll to make quantity section visible
      await tester.ensureVisible(quantitySection);
      await tester.pumpAndSettle();

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      // Ensure the button is visible before tapping
      await tester.ensureVisible(quantityAddButton);
      await tester.pumpAndSettle();

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing (2 seconds + buffer)
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('profile screen journey', (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Navigate to Profile screen
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);

      // Fill in name field
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      // Fill in location field
      final locationField = find.byType(TextField).last;
      await tester.enterText(locationField, 'London');
      await tester.pumpAndSettle();

      // Save profile - it's an ElevatedButton, not StyledButton
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should return to order screen and show welcome message
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(
          find.text('Welcome, John Doe! Ordering from London'), findsOneWidget);
    });

    testWidgets('settings screen journey', (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Navigate to Settings screen
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);

      // Find the slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Change font size by dragging slider
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Go back to order screen using the Back to Order button
      final backToOrderButton =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      await tester.tap(backToOrderButton);
      await tester.pumpAndSettle();

      // Verify we're back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('order history journey', (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Navigate to Order History (skip placing order since database may not persist)
      final orderHistoryButton =
          find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      // Verify we navigated to Order History screen
      expect(find.text('Order History'), findsOneWidget);

      // The screen should show either:
      // 1. Loading indicator (CircularProgressIndicator)
      // 2. Empty state ("No orders yet" with Back button)
      // 3. Orders list (ListTile widgets)
      // Just verify the title is there, meaning navigation worked
    });

    testWidgets('cart management - increment, decrement, remove',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Add a sandwich to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('1x Veggie Delight'), findsOneWidget);

      // Find increment button (+ icon in cart)
      final incrementButtons = find.byIcon(Icons.add);
      if (tester.any(incrementButtons)) {
        await tester.tap(incrementButtons.first);
        await tester.pumpAndSettle();
        // Quantity should increase
        expect(find.text('2x Veggie Delight'), findsOneWidget);
      }

      // Find decrement button (- icon in cart)
      final decrementButtons = find.byIcon(Icons.remove);
      if (tester.any(decrementButtons)) {
        await tester.tap(decrementButtons.first);
        await tester.pumpAndSettle();
        // Quantity should decrease back
        expect(find.text('1x Veggie Delight'), findsOneWidget);
      }

      // Find delete button
      final deleteButtons = find.byIcon(Icons.delete);
      if (tester.any(deleteButtons)) {
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();
        // Cart should be empty
        expect(find.text('Your cart is empty'), findsOneWidget);
      }
    });

    testWidgets('sandwich customization - bread type and size',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Change bread type
      final breadDropdown = find.byType(DropdownMenu<BreadType>);
      await tester.ensureVisible(breadDropdown);
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Wheat').last);
      await tester.pumpAndSettle();

      // Toggle size from Footlong to Six-inch
      final sizeSwitch = find.byType(Switch);
      await tester.ensureVisible(sizeSwitch);
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify price changed (six-inch should be cheaper)
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Six-inch price should be £5.50 (not £11.00)
      expect(find.text('Total: £5.50'), findsOneWidget);
    });

    testWidgets('multiple different items checkout',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Add first sandwich (Veggie Delight)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Change to Chicken Teriyaki
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add second sandwich
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart has 2 items
      expect(find.text('Cart: 2 items - £22.00'), findsOneWidget);

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify both sandwiches are in cart
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);

      // Complete checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Verify cart is cleared
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('quantity decrease button functionality',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      await tester.ensureVisible(quantitySection);
      await tester.pumpAndSettle();

      // Find the + button to increase quantity first
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;
      await tester.ensureVisible(quantityAddButton);
      await tester.pumpAndSettle();

      // Increase to 3
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      // Find the - button to decrease quantity
      final removeButtons = find.byIcon(Icons.remove);
      final quantityRemoveButton = removeButtons.first;
      await tester.ensureVisible(quantityRemoveButton);
      await tester.pumpAndSettle();

      // Decrease quantity
      await tester.tap(quantityRemoveButton);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Add to cart with quantity 2
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 2 items - £22.00'), findsOneWidget);
    });

    testWidgets('navigation flow - back from various screens',
        (WidgetTester tester) async {
      app.mainTest(initializeFirebase: false);
      await tester.pumpAndSettle();

      // Navigate to Settings and back
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // Click logo to go back
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Add item and navigate to cart and back
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart'), findsOneWidget);

      // Back from cart
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    // Feel free to add more tests (e.g., to check saved orders, etc.)
  });
}
