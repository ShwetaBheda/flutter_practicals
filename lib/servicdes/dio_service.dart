import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get('https://dummyjson.com/products');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
