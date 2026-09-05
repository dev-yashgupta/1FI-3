import '../models/product.dart';
import 'api_client.dart';
import 'product_datasource.dart';

/// Fetches product data from the live Express + Supabase backend.
/// Implements `ProductDataSource` — drop-in for `MockProductDataSource`.
class RemoteProductDataSource implements ProductDataSource {
  final ApiClient _client;

  RemoteProductDataSource({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  /// GET /api/products  →  `List<Product>`
  @override
  Future<List<Product>> getProducts() async {
    final data = await _client.get<dynamic>('/api/products');
    if (data is! List) {
      throw const ApiException(
        'Unexpected response format from /api/products',
      );
    }
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/products/:slug  →  Product?  (null on 404)
  @override
  Future<Product?> getProductBySlug(String slug) async {
    try {
      final data = await _client.get<dynamic>('/api/products/$slug');
      if (data == null) return null;
      return Product.fromJson(data as Map<String, dynamic>);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }
}
