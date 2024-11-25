import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practical/models/product.dart';
import 'package:flutter_practical/repositories/product_repo.dart';

// States

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  ProductLoaded({required this.products, required this.filteredProducts});
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

// Events

abstract class ProductEvent {}

class FetchProductsEvent extends ProductEvent {}

class SearchProductEvent extends ProductEvent {
  final String query;
  SearchProductEvent({required this.query});
}

class ToggleCardExpansionEvent extends ProductEvent {
  final int index;
  ToggleCardExpansionEvent({required this.index});
}

// Bloc

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SearchProductEvent>(_onSearchProducts);
    on<ToggleCardExpansionEvent>(_onToggleCardExpansion);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError(message: 'Failed to load products'));
    }
  }

  Future<void> _onSearchProducts(
      SearchProductEvent event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is ProductLoaded) {
      final filteredProducts = state.products
          .where((product) =>
              product.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(ProductLoaded(
          products: state.products, filteredProducts: filteredProducts));
    }
  }

  Future<void> _onToggleCardExpansion(
      ToggleCardExpansionEvent event, Emitter<ProductState> emit) async {}
}
