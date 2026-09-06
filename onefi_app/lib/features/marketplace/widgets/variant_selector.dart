import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/product.dart';
import '../../../data/models/product_variant.dart';

/// Variant selector — storage chips + color swatches with price diff.
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
    final storages         = product.uniqueStorages;
    final selectedStorage  = selected?.storage ?? storages.first;
    final colorVariants    = product.variants
        .where((v) => v.storage == selectedStorage)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Storage ──────────────────────────────
        if (storages.length > 1) ...[
          _Label('Storage'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: storages.map((s) {
              final isActive = s == selectedStorage;
              final variant = product.variants.firstWhere(
                (v) => v.storage == s && v.inStock,
                orElse: () => product.variants
                    .firstWhere((v) => v.storage == s),
              );
              // Price diff vs currently selected
              final diff = selected != null
                  ? variant.price - selected!.price
                  : 0.0;
              return _StorageChip(
                label: s,
                priceDiff: diff,
                isSelected: isActive,
                inStock: variant.inStock,
                onTap: () => onChanged(variant),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
        ],

        // ── Color ─────────────────────────────────
        if (colorVariants.length > 1) ...[
          _Label('Color'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colorVariants.map((v) => _ColorChip(
                  variant: v,
                  isSelected: v.id == selected?.id,
                  onTap: () => onChanged(v),
                )).toList(),
          ),
        ],
      ],
    );
  }
}

// ─── Label ────────────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF374151),
      ),
    );
  }
}

// ─── Storage chip ─────────────────────────────────────────────────────────────

class _StorageChip extends StatelessWidget {
  final String label;
  final double priceDiff;
  final bool isSelected, inStock;
  final VoidCallback onTap;

  const _StorageChip({
    required this.label,
    required this.priceDiff,
    required this.isSelected,
    required this.inStock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: inStock ? onTap : null,
      child: Opacity(
        opacity: inStock ? 1.0 : 0.45,
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF111827),
                ),
              ),
              // Show price diff on non-selected chips
              if (!isSelected && priceDiff != 0) ...[
                const SizedBox(height: 2),
                Text(
                  priceDiff > 0
                      ? '+${CurrencyFormatter.format(priceDiff)}'
                      : CurrencyFormatter.format(priceDiff),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: priceDiff > 0
                        ? const Color(0xFF9CA3AF)
                        : AppColors.success,
                  ),
                ),
              ],
              if (!inStock) ...[
                const SizedBox(height: 2),
                const Text('Out of stock',
                    style: TextStyle(
                        fontSize: 8,
                        color: AppColors.error,
                        fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Color chip ───────────────────────────────────────────────────────────────

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
                ? AppColors.primary.withValues(alpha: 0.07)
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
              // Color swatch with border
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: variant.colorSwatch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                variant.color,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF374151),
                ),
              ),
              if (!variant.inStock) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('OOS',
                      style: TextStyle(
                          fontSize: 8,
                          color: AppColors.error,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
