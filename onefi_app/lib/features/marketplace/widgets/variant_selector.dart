import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product.dart';
import '../../../data/models/product_variant.dart';

/// Reusable variant selector — shows storage chips and color swatches.
class VariantSelector extends StatelessWidget {
  final Product product;
  final ProductVariant? selected;
  final ValueChanged<ProductVariant> onChanged;

  const VariantSelector({
    super.key,
    required this.product,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final storages = product.uniqueStorages;
    final selectedStorage = selected?.storage ?? storages.first;

    // Variants matching current storage
    final colorVariants = product.variants
        .where((v) => v.storage == selectedStorage)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Storage selector ──────────────────────
        if (storages.length > 1) ...[
          Text('Storage', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: storages.map((s) {
              final isSelected = s == selectedStorage;
              // Find first in-stock variant for this storage
              final variantForStorage = product.variants.firstWhere(
                (v) => v.storage == s && v.inStock,
                orElse: () => product.variants.firstWhere(
                  (v) => v.storage == s,
                  orElse: () => product.variants.first,
                ),
              );
              return _StorageChip(
                label: s,
                isSelected: isSelected,
                onTap: () => onChanged(variantForStorage),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // ── Color selector ────────────────────────
        if (colorVariants.length > 1) ...[
          Text('Color', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colorVariants.map((v) {
              final isSelected = v.id == selected?.id;
              return _ColorChip(
                variant: v,
                isSelected: isSelected,
                onTap: () => onChanged(v),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _StorageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StorageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final ProductVariant variant;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorChip({
    required this.variant,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: variant.inStock ? onTap : null,
      child: Opacity(
        opacity: variant.inStock ? 1.0 : 0.4,
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color swatch dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: variant.colorSwatch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                variant.color,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (!variant.inStock) ...[
                const SizedBox(width: 4),
                Text('(OOS)',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.error)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
