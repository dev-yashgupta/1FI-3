import 'package:flutter/material.dart';

/// Represents a single product variant (color + storage combination).
class ProductVariant {
  final String id;
  final String productId;
  final String storage;
  final String color;
  final Color colorSwatch;
  final String finish;
  final double price;
  final double mrp;
  final String imageUrl;
  final bool inStock;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.storage,
    required this.color,
    required this.colorSwatch,
    required this.finish,
    required this.price,
    required this.mrp,
    required this.imageUrl,
    required this.inStock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? json['product_id']?.toString() ?? '',
      storage: json['storage']?.toString() ?? 'N/A',
      color: json['color']?.toString() ?? '',
      colorSwatch: _parseColor(json['colorHex']?.toString()),
      finish: json['finish']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      inStock: json['inStock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'storage': storage,
    'color': color,
    'colorHex': '#${colorSwatch.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    'finish': finish,
    'price': price,
    'mrp': mrp,
    'imageUrl': imageUrl,
    'inStock': inStock,
  };

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF9E9E9E);
    final cleaned = hex.replaceAll('#', '');
    try {
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return const Color(0xFF9E9E9E);
    }
  }

  ProductVariant copyWith({
    String? id,
    String? productId,
    String? storage,
    String? color,
    Color? colorSwatch,
    String? finish,
    double? price,
    double? mrp,
    String? imageUrl,
    bool? inStock,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      storage: storage ?? this.storage,
      color: color ?? this.color,
      colorSwatch: colorSwatch ?? this.colorSwatch,
      finish: finish ?? this.finish,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      imageUrl: imageUrl ?? this.imageUrl,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProductVariant && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
