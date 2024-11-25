import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class CartState {}

class CartInitial extends CartState {
  final List<dynamic> cartItems;

  CartInitial({required this.cartItems});
}

// Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final dynamic product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final dynamic product;

  RemoveFromCart(this.product);
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial(cartItems: []));

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (state is CartInitial) {
      final currentState = state as CartInitial;
      final cartItems = List<dynamic>.from(currentState.cartItems);

      if (event is AddToCart) {
        cartItems.add(event.product);
      } else if (event is RemoveFromCart) {
        cartItems.remove(event.product);
      }

      yield CartInitial(cartItems: cartItems);
    }
  }
}
