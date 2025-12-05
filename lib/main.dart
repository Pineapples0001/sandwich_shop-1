import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: const OrderScreen(maxQuantity: 5),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          default:
            return MaterialPageRoute(
                builder: (_) => const OrderScreen(maxQuantity: 5));
        }
      },
    );
  }
}
