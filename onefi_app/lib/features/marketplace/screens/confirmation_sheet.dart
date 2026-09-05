import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/marketplace_provider.dart';

/// Bottom sheet shown when the user taps "Proceed with Selected Plan".
void showConfirmationSheet(BuildContext context, ProductDetailState state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ConfirmationSheet(state: state),
  );
}

class _ConfirmationSheet extends StatelessWidget {
  final ProductDetailState state;
  const _ConfirmationSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final product = state.product!;
    final variant = state.selectedVariant!;
    final plan = state.selectedEmiPlan!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 12),

          Text('Plan Selected', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 4),
          Text('Review your selection below',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),

          // ── Summary card ──────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row(label: 'Product', value: product.name),
                const Divider(height: 20, color: AppColors.divider),
                _Row(
                    label: 'Variant',
                    value: '${variant.storage} · ${variant.color}'),
                const Divider(height: 20, color: AppColors.divider),
                _Row(
                    label: 'Monthly EMI',
                    value: CurrencyFormatter.formatPerMonth(plan.monthlyAmount),
                    highlight: true),
                const Divider(height: 20, color: AppColors.divider),
                _Row(
                    label: 'Tenure',
                    value: '${plan.tenureMonths} months'),
                const Divider(height: 20, color: AppColors.divider),
                _Row(
                    label: 'Interest',
                    value: plan.isNoCost
                        ? '0% (No-cost EMI)'
                        : '${plan.interestRate}% p.a.'),
                if (plan.hasCashback) ...[
                  const Divider(height: 20, color: AppColors.divider),
                  _Row(
                      label: 'Cashback',
                      value: CurrencyFormatter.format(plan.cashback),
                      valueColor: AppColors.success),
                ],
                const Divider(height: 20, color: AppColors.divider),
                _Row(label: 'Bank / Lender', value: plan.bankName),
              ],
            ),
          ),

          const SizedBox(height: 24),

          AppButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar(context, product.name);
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Change Plan',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'EMI plan confirmed for $productName!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? valueColor;

  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: highlight
                ? AppTextStyles.headlineSmall.copyWith(color: AppColors.primary)
                : AppTextStyles.labelLarge.copyWith(
                    color: valueColor ?? AppColors.textPrimary),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
