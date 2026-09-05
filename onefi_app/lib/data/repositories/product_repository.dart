import '../datasources/mock_product_datasource.dart';
import '../models/product.dart';

/// Repository abstraction — UI only talks to this.
/// Switch between mock and remote by changing the datasource.
class ProductRepository {
  final MockProductDataSource _dataSource;

  ProductRepository({MockProductDataSource? dataSource})
      : _dataSource = dataSource ?? MockProductDataSource();

  /// Returns all products for the marketplace listing.
  Future<List<Product>> getProducts() => _dataSource.getProducts();

  /// Returns a single product by slug for the detail screen.
  Future<Product?> getProductBySlug(String slug) =>
      _dataSource.getProductBySlug(slug);
}
