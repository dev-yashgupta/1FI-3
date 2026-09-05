import 'package:dio/dio.dart';
import '../models/product.dart';
import 'api_client.dart';

/// Fetches product data from the live Express + Supabase backend.
/// Replace [MockProductDataSource] with this once backend is deployed.
class RemoteProductDataSource {
  final ApiClient _client;

  RemoteProductDataSource({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _client.get<List<dynamic>>('/api/products');
      final data = response.data;
      if (data == null) return [];
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Failed to load products',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Product?> getProductBySlug(String slug) async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/api/products/$slug');
      final data = response.data;
      if (data == null) return null;
      return Product.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw ApiException(
        e.message ?? 'Failed to load product',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
