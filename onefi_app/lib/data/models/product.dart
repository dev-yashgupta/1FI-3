import 'emi_plan.dart';
import 'product_variant.dart';

/// Top-level product model for the 1Fi Marketplace.
class Product {
  final String id;
  final String name;
  final String slug;
  final String brand;
  final String description;
  final String category;
  final String imageUrl;
  final double mrp;
  final double basePrice;
  final double rating;
  final int reviewCount;
  final List<String> badges;
  final List<ProductVariant> variants;
  final List<EmiPlan> emiPlans;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.brand,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.mrp,
    required this.basePrice,
    required this.rating,
    required this.reviewCount,
    required this.badges,
    required this.variants,
    required this.emiPlans,
  });

  /// Lowest variant price
  double get lowestPrice {
    if (variants.isEmpty) return basePrice;
    return variants
        .map((v) => v.price)
        .reduce((a, b) => a < b ? a : b);
  }

  /// Shortest EMI tenure plan
  EmiPlan? get shortestEmiPlan {
    if (emiPlans.isEmpty) return null;
    return emiPlans.reduce((a, b) => a.tenureMonths < b.tenureMonths ? a : b);
  }

  /// Discount percentage based on MRP vs base price
  int get discountPercent {
    if (mrp <= 0) return 0;
    return (((mrp - basePrice) / mrp) * 100).round();
  }

  List<String> get uniqueStorages =>
      variants.map((v) => v.storage).toSet().toList()..sort();

  List<String> get uniqueColors =>
      variants.map((v) => v.color).toSet().toList();

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantsJson = json['variants'] as List<dynamic>? ?? [];
    final emiPlansJson = json['emiPlans'] as List<dynamic>? ?? json['emi_plans'] as List<dynamic>? ?? [];

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['basePrice'] ?? json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      badges: List<String>.from(json['badges'] as List<dynamic>? ?? []),
      variants: variantsJson.map((v) => ProductVariant.fromJson(v as Map<String, dynamic>)).toList(),
      emiPlans: emiPlansJson.map((e) => EmiPlan.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'brand': brand,
    'description': description,
    'category': category,
    'imageUrl': imageUrl,
    'mrp': mrp,
    'basePrice': basePrice,
    'rating': rating,
    'reviewCount': reviewCount,
    'badges': badges,
    'variants': variants.map((v) => v.toJson()).toList(),
    'emiPlans': emiPlans.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
