import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practical/models/cart.dart';
import 'package:flutter_practical/models/product.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is AddToCartEvent) {
      final product = event.product;
      final existingItem = _cartItems.firstWhere(
          (item) => item.product.id == product.id,
          orElse: () => CartItem(product: product));

      if (_cartItems.contains(existingItem)) {
        existingItem.quantity++;
      } else {
        _cartItems.add(CartItem(product: product));
      }
      yield CartUpdated(cartItems: _cartItems);
    } else if (event is RemoveFromCartEvent) {
      _cartItems.removeWhere((item) => item.product.id == event.productId);
      yield CartUpdated(cartItems: _cartItems);
    }
  }
}

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> cartItems;

  CartUpdated({required this.cartItems});
}

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;

  AddToCartEvent({required this.product});
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  RemoveFromCartEvent({required this.productId});
}
