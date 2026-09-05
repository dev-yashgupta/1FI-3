import 'package:flutter/foundation.dart';
import '../datasources/mock_product_datasource.dart';
import '../datasources/product_datasource.dart';
import '../datasources/remote_product_datasource.dart';
import '../models/product.dart';

/// Repository that the UI layer depends on.
///
/// Data source selection:
///   - If [useMock] is forced to true  → always MockProductDataSource
///   - If [useMock] is forced to false → always RemoteProductDataSource
///   - Default (null)                  → RemoteProductDataSource in release,
///                                       MockProductDataSource in debug
///                                       (override via --dart-define=USE_MOCK=true)
class ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepository({ProductDataSource? dataSource})
      : _dataSource = dataSource ?? _defaultDataSource();

  static ProductDataSource _defaultDataSource() {
    // Check build-time flag first
    const forceMock = bool.fromEnvironment('USE_MOCK', defaultValue: false);
    if (forceMock) return MockProductDataSource();

    // In debug mode use mock until backend is live.
    // Set useMockInDebug = false once your Supabase backend is running.
    if (kDebugMode) {
      const useMockInDebug = true;
      if (useMockInDebug) return MockProductDataSource();
    }

    return RemoteProductDataSource();
  }

  /// All products for the marketplace listing screen.
  Future<List<Product>> getProducts() => _dataSource.getProducts();

  /// Single product by slug for the detail screen.
  Future<Product?> getProductBySlug(String slug) =>
      _dataSource.getProductBySlug(slug);
}
