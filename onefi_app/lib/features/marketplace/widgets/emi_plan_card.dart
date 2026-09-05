import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/emi_plan.dart';

/// Selectable EMI plan card matching 1Fi's card design language.
class EmiPlanCard extends StatelessWidget {
  final EmiPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const EmiPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Radio indicator ────────────────────
            AnimatedContainer(
              duration: AppConstants.animFast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 14),

            // ── Plan details ───────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Monthly amount
                      Text(
                        CurrencyFormatter.formatMonthly(plan.monthlyAmount),
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Tag badge
                      if (plan.hasTag)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: plan.tag == 'Popular'
                                ? AppColors.primary
                                : AppColors.emiBadge,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusPill),
                          ),
                          child: Text(
                            plan.tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Tenure
                      Text(
                        '${plan.tenureMonths} months',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(width: 10),
                      // Interest rate
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: plan.isNoCost
                              ? AppColors.emiBadge.withValues(alpha: 0.12)
                              : AppColors.warning.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                        ),
                        child: Text(
                          plan.isNoCost
                              ? '0% interest'
                              : '${plan.interestRate}% p.a.',
                          style: TextStyle(
                            color: plan.isNoCost
                                ? AppColors.emiBadge
                                : AppColors.warning,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Cashback
                  if (plan.hasCashback) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.card_giftcard_rounded,
                            size: 12, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          'Additional cashback ${CurrencyFormatter.format(plan.cashback)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
