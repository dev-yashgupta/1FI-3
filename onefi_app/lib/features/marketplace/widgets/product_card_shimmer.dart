import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

/// Shimmer skeleton — fills whatever mainAxisExtent the grid allocates.
/// Uses ClipRect to prevent any content overflow.
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          // Column fills the full allocated height — no overflow possible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Image area — takes all remaining space above info section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(14)),
                  ),
                ),
              ),

              // Fixed-height info skeleton — must stay ≤ infoH (168px)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Box(width: 44,             height: 8),   // brand
                    const SizedBox(height: 5),
                    _Box(width: double.infinity, height: 12),  // name ln1
                    const SizedBox(height: 3),
                    _Box(width: 100,            height: 12),  // name ln2
                    const SizedBox(height: 5),
                    _Box(width: 80,             height: 11),  // rating
                    const SizedBox(height: 5),
                    _Box(width: 90,             height: 13),  // price
                    const SizedBox(height: 2),
                    _Box(width: 65,             height: 10),  // mrp
                    const SizedBox(height: 5),
                    _Box(width: 120,            height: 10),  // emi
                    const SizedBox(height: 9),
                    _Box(width: double.infinity, height: 32),  // button
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

class _Box extends StatelessWidget {
  final double width;
  final double height;
  const _Box({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
