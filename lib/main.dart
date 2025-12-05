import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Cart _sharedCart = Cart();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => OrderScreen(
                maxQuantity: 5,
                cart: _sharedCart,
              ),
            );
          case '/cart':
            return MaterialPageRoute(
              builder: (_) => CartScreen(
                cart: _sharedCart,
                maxQuantity: 5,
              ),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            );
          case '/about':
            return MaterialPageRoute(
              builder: (_) => const AboutScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => OrderScreen(
                maxQuantity: 5,
                cart: _sharedCart,
              ),
            );
        }
      },
    );
  }
}
