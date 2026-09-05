import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Top Brands — no implementation required per assignment spec.
class TopBrandsScreen extends StatelessWidget {
  const TopBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.storefront_outlined, size: 56, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Top Brands', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('Coming soon', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
