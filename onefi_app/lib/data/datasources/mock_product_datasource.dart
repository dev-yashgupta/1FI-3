import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

/// Loads product data from the local mock JSON asset.
/// Swap this for [RemoteProductDataSource] when the backend is live.
class MockProductDataSource {
  static const String _assetPath = 'assets/mock/products.json';

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    final String raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product?> getProductBySlug(String slug) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
