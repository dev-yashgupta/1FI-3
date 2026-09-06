import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/api_client.dart';
import '../datasources/mock_product_datasource.dart';
import '../datasources/product_datasource.dart';
import '../datasources/remote_product_datasource.dart';
import '../models/product.dart';

/// Central repository — the only data access point for the UI.
///
/// Data source selection (in priority order):
///   1. --dart-define=USE_MOCK=true   → always mock
///   2. --dart-define=USE_MOCK=false  → always remote
///   3. Debug build (default)         → mock
///   4. Release build (default)       → remote
///
/// API URL override:
///   --dart-define=API_BASE_URL=http://192.168.1.100:3000
class ProductRepository {
  final ProductDataSource _dataSource;
  final MockProductDataSource _fallback = MockProductDataSource();

  ProductRepository({ProductDataSource? dataSource})
      : _dataSource = dataSource ?? _resolve();

  static ProductDataSource _resolve() {
    if (AppConstants.useMock) {
      if (kDebugMode) debugPrint('[Repo] → MockProductDataSource');
      return MockProductDataSource();
    }
    if (kDebugMode) {
      debugPrint('[Repo] → RemoteProductDataSource (${AppConstants.apiBaseUrl})');
    }
    return RemoteProductDataSource();
  }

  bool get _isRemote => _dataSource is RemoteProductDataSource;

  // ─── Public API ──────────────────────────────────────────────────────────

  /// All products for the marketplace listing.
  /// Automatically falls back to mock data if the backend is unreachable.
  Future<List<Product>> getProducts() async {
    try {
      return await _dataSource.getProducts();
    } on ApiException catch (e) {
      if (_isRemote) {
        if (kDebugMode) debugPrint('[Repo] Remote error: ${e.message} — using mock fallback');
        return _fallback.getProducts();
      }
      rethrow;
    } catch (e) {
      if (_isRemote) {
        if (kDebugMode) debugPrint('[Repo] Unexpected error — using mock fallback: $e');
        return _fallback.getProducts();
      }
      rethrow;
    }
  }

  /// Single product by slug for the detail screen.
  /// Falls back to mock if backend is unreachable.
  Future<Product?> getProductBySlug(String slug) async {
    try {
      return await _dataSource.getProductBySlug(slug);
    } on ApiException catch (e) {
      if (_isRemote) {
        if (kDebugMode) debugPrint('[Repo] Remote error: ${e.message} — using mock fallback');
        return _fallback.getProductBySlug(slug);
      }
      rethrow;
    } catch (e) {
      if (_isRemote) {
        if (kDebugMode) debugPrint('[Repo] Unexpected error — using mock fallback: $e');
        return _fallback.getProductBySlug(slug);
      }
      rethrow;
    }
  }
}
