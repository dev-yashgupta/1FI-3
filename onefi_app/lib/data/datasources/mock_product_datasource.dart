import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';
import 'product_datasource.dart';

/// Loads product data from the bundled mock JSON asset.
/// Implements [ProductDataSource] — drop-in replacement for [RemoteProductDataSource].
class MockProductDataSource implements ProductDataSource {
  static const String _assetPath = 'assets/mock/products.json';

  @override
  Future<List<Product>> getProducts() async {
    // Simulate realistic network latency
    await Future.delayed(const Duration(milliseconds: 800));
    final String raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product?> getProductBySlug(String slug) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
