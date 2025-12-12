import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('App', () {
    testWidgets('creates App widget successfully', (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App provides ChangeNotifierProvider with Cart',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MaterialApp));
      final Cart cart = Provider.of<Cart>(context, listen: false);
      expect(cart, isNotNull);
    });

    testWidgets('App has OrderScreen as home', (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets('App has correct title', (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final MaterialApp materialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Sandwich Shop App');
    });

    testWidgets('App disables debug banner', (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final MaterialApp materialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('OrderScreen has maxQuantity of 5',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final OrderScreen orderScreen =
          tester.widget<OrderScreen>(find.byType(OrderScreen));
      expect(orderScreen.maxQuantity, 5);
    });
  });

  group('main', () {
    testWidgets('main initializes and runs app', (WidgetTester tester) async {
      // Since main() calls runApp, we need to test it differently
      // We'll test that the app can be initialized properly
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });
}
