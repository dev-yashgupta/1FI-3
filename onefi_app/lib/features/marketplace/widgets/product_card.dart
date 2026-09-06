import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../data/models/product.dart';

/// Reusable product card for the marketplace listing.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final emi = product.shortestEmiPlan;

    return GestureDetector(
      onTap: () => context.push('/marketplace/${product.slug}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
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
            // ── Product image ──────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusLG)),
                  child: AppNetworkImage(
                    url: product.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                // Badges
                if (product.badges.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _BadgeRow(badges: product.badges),
                  ),
                // Discount chip
                if (product.discountPercent > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text(
                        '${product.discountPercent}% off',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Product info ───────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brand.toUpperCase(),
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 2),
                  // Name
                  Text(
                    product.name,
                    style: AppTextStyles.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Pricing row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'From ${CurrencyFormatter.format(product.lowestPrice)}',
                        style: AppTextStyles.priceEmi,
                      ),
                      const SizedBox(width: 6),
                      if (product.mrp > product.lowestPrice)
                        Text(
                          CurrencyFormatter.format(product.mrp),
                          style: AppTextStyles.priceMrp,
                        ),
                    ],
                  ),

                  // EMI teaser
                  if (emi != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emiGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusSM),
                          ),
                          child: Text(
                            '${emi.isNoCost ? "0%" : "${emi.interestRate}%"} interest',
                            style: TextStyle(
                              color: AppColors.emiGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${CurrencyFormatter.formatMonthly(emi.monthlyAmount)} × ${emi.tenureMonths}m',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push('/marketplace/${product.slug}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusPill),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
    );
  }
}

class _BadgeRow extends StatelessWidget {
  final List<String> badges;
  const _BadgeRow({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: badges.take(2).map((b) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        ),
        child: Text(b,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600)),
      )).toList(),
    );
  }
}
