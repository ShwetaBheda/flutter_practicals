import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practical/blocs/cart/cart_bloc.dart';
import 'package:flutter_practical/widgets/drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      drawer: const SharedNavigationDrawer(currentScreen: 'Cart'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            final cartItems = state.cartItems;
            final totalCount = cartItems.fold<int>(
              0,
              (previousValue, element) => previousValue + element.quantity,
            );

            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text('Total Count'),
                    trailing: Text('$totalCount'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return ListTile(
                        title: Text(cartItem.product.title),
                        subtitle: Text(
                          'Price: \$${cartItem.product.price} x ${cartItem.quantity}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context).add(
                              RemoveFromCartEvent(
                                  productId: cartItem.product.id),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Your cart is empty.'));
        },
      ),
    );
  }
}
