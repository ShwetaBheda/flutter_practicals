import 'package:flutter/material.dart';
import 'package:flutter_practical/screens/cart_Screen.dart';
import 'package:flutter_practical/screens/dashboard_screen.dart';
import 'package:flutter_practical/screens/product_screen.dart';

class SharedNavigationDrawer extends StatelessWidget {
  final String currentScreen;

  const SharedNavigationDrawer({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Text(
                'App Navigation',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            selected: currentScreen == 'Dashboard',
            onTap: () {
              if (currentScreen != 'Dashboard') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Products'),
            leading: const Icon(Icons.shopping_bag),
            selected: currentScreen == 'Products',
            onTap: () {
              if (currentScreen != 'Products') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Cart'),
            leading: const Icon(Icons.shopping_cart),
            selected: currentScreen == 'Cart',
            onTap: () {
              if (currentScreen != 'Cart') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
