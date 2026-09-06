import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../data/models/product.dart';

/// Polished product card with wishlist, rating, EMI teaser and press animation.
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
    lowerBound: 0.96,
    upperBound: 1.0,
    value: 1.0,
  );

  bool _wishlisted = false;

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressCtrl.reverse();
  void _onTapUp(_)   => _pressCtrl.forward();
  void _onTapCancel() => _pressCtrl.forward();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final emi     = product.shortestEmiPlan;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp:   _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => context.push('/marketplace/${product.slug}'),
      child: ScaleTransition(
        scale: _pressCtrl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area ──────────────────────
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                      child: SizedBox.expand(
                        child: AppNetworkImage(
                          url: product.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Discount badge
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${product.discountPercent}% off',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    // Wishlist button
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _wishlisted = !_wishlisted),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            _wishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 15,
                            color: _wishlisted
                                ? AppColors.error
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info area ───────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand
                    Text(
                      product.brand.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Rating row
                    if (product.rating > 0) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 11,
                              color: Color(0xFFFBBF24)),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '(${product.reviewCount})',
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 5),
                    // Price
                    Text(
                      'From ${CurrencyFormatter.format(product.lowestPrice)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.mrp > product.lowestPrice) ...[
                      const SizedBox(height: 1),
                      Text(
                        CurrencyFormatter.format(product.mrp),
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF9CA3AF),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Color(0xFF9CA3AF),
                        ),
                        maxLines: 1,
                      ),
                    ],
                    // EMI teaser
                    if (emi != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.emiGreen
                                    .withValues(alpha: 0.10),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${emi.isNoCost ? "0% EMI" : "${emi.interestRate}%"}'
                                ' · ${CurrencyFormatter.formatMonthly(emi.monthlyAmount)}',
                                style: TextStyle(
                                  color: AppColors.emiGreen,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // CTA
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => context
                            .push('/marketplace/${product.slug}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
