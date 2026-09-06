import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

/// Shimmer skeleton — uses flexible layout, no fixed heights that overflow.
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image placeholder — uses AspectRatio like the real card
            AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Box(width: 50, height: 9),
                  const SizedBox(height: 6),
                  _Box(width: double.infinity, height: 13),
                  const SizedBox(height: 3),
                  _Box(width: 110, height: 13),
                  const SizedBox(height: 8),
                  _Box(width: 90, height: 13),
                  const SizedBox(height: 3),
                  _Box(width: 70, height: 11),
                  const SizedBox(height: 6),
                  _Box(width: 120, height: 11),
                  const SizedBox(height: 10),
                  _Box(width: double.infinity, height: 34),
                ],
              ),
            ),
          ],
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
