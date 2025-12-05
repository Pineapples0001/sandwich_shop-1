import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final Cart? cart;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final drawerWidth = isWideScreen ? 300.0 : 280.0;

    return Drawer(
      width: drawerWidth,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sandwich Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fresh & Delicious',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            title: 'Order Sandwiches',
            route: '/order',
            isSelected: currentRoute == '/order',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.shopping_cart,
            title: 'View Cart',
            route: '/cart',
            isSelected: currentRoute == '/cart',
            badge: cart != null && cart!.countOfItems > 0
                ? cart!.countOfItems.toString()
                : null,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.person,
            title: 'My Profile',
            route: '/profile',
            isSelected: currentRoute == '/profile',
          ),
          const Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.info,
            title: 'About Us',
            route: '/about',
            isSelected: currentRoute == '/about',
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    String? badge,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.deepPurple : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.deepPurple : Colors.grey[900],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: badge != null
          ? CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: isSelected,
      selectedTileColor: Colors.deepPurple.withOpacity(0.1),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        if (!isSelected) {
          _navigateToRoute(context, route);
        }
      },
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    switch (route) {
      case '/order':
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        break;
      case '/cart':
        Navigator.of(context).pushNamed('/cart');
        break;
      case '/profile':
        Navigator.of(context).pushNamed('/profile');
        break;
      case '/about':
        Navigator.of(context).pushNamed('/about');
        break;
    }
  }
}
