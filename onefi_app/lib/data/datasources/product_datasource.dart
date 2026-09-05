import '../models/product.dart';

/// Contract that both MockProductDataSource and RemoteProductDataSource implement.
/// ProductRepository depends on this — never on the concrete class.
abstract class ProductDataSource {
  Future<List<Product>> getProducts();
  Future<Product?> getProductBySlug(String slug);
}
