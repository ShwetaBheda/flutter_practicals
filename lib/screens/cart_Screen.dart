import 'package:flutter/material.dart';
import 'package:flutter_practical/widgets/drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      drawer: const SharedNavigationDrawer(currentScreen: 'Cart'),
      body: const Column(
        children: [
          // TotalCountCard(),
          // Expanded(
          //   // child: CartItemList(),
          // ),
        ],
      ),
    );
  }
}
