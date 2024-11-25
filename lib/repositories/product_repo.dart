
import 'package:flutter_practical/models/product.dart';
import 'package:flutter_practical/servicdes/dio_service.dart';

class ProductRepository {
  final DioService dioService;

  ProductRepository(this.dioService);

  Future<List<Product>> getProducts() async {
    try {
      final data = await dioService.fetchProducts();
      return (data['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse products');
    }
  }
}
