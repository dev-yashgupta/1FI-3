import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Nearby Stores — no implementation required per assignment spec.
class NearbyStoresScreen extends StatelessWidget {
  const NearbyStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, size: 56, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Nearby Stores', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('Coming soon', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
