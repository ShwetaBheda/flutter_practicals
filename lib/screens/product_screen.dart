import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practical/blocs/cart/cart_bloc.dart';
import 'package:flutter_practical/blocs/products/products_bloc.dart';
import 'package:flutter_practical/models/product.dart';
import 'package:flutter_practical/repositories/product_repo.dart';
import 'package:flutter_practical/servicdes/dio_service.dart';
import 'package:flutter_practical/widgets/drawer.dart';

class ProductScreen extends StatelessWidget {
  final ProductBloc productBloc = ProductBloc(ProductRepository(DioService()));

  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      drawer: const SharedNavigationDrawer(currentScreen: 'Products'),
      body: BlocProvider(
        create: (context) => productBloc..add(FetchProductsEvent()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else if (state is ProductLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        productBloc.add(SearchProductEvent(query: query));
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of items in a row
                        crossAxisSpacing: 2.0, // Space between columns
                        mainAxisSpacing: 2.0, // Space between rows
                        childAspectRatio: 0.45, // Aspect ratio of each item
                      ),
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onCardTapped: () {
                            // Handle card tap functionality
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onCardTapped;

  const ProductCard(
      {super.key, required this.product, required this.onCardTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Ensures content is spread out
          children: [
            // Image Section
            SizedBox(
              height: 150, // Fixed image height
              width: double.infinity, // Full width for the image
              child: Image.network(
                product.images[0], // Display the first image
                fit: BoxFit.cover, // Ensure the image covers the container
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start
                children: [
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Category
                  Text('Category: ${product.category}'),
                  // Price
                  Text('Price: \$${product.price}'),
                  // Brand
                  Text('Brand: ${product.brand}'),
                  // Discount
                  Text('Discount: ${product.discountPercentage}%'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity, // Button takes full width
                child: ElevatedButton(
                  onPressed: () {
                    // Get the CartBloc and dispatch AddToCartEvent
                    // Access the CartBloc using BlocProvider.of()
                    // BlocProvider.of<CartBloc>(context)
                    //     .add(AddToCartEvent(product: product));

                    // Show a Snackbar message indicating the product is added to the cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
