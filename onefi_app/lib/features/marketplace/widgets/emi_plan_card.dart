import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/emi_plan.dart';

/// Enhanced EMI plan card — shows monthly amount, tenure, interest,
/// total payable, and cashback savings.
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

  double get _totalPayable =>
      plan.monthlyAmount * plan.tenureMonths;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // ── Main row ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radio
                  AnimatedContainer(
                    duration: AppConstants.animFast,
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 13)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Monthly + tag
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: CurrencyFormatter.format(
                                          plan.monthlyAmount),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected
                                            ? AppColors.primary
                                            : const Color(0xFF111827),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '/month',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (plan.hasTag) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: plan.tag == 'Popular'
                                      ? AppColors.primary
                                      : AppColors.emiGreen,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  plan.tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Tenure + interest chips
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _InfoChip(
                              label: '${plan.tenureMonths} months',
                              icon: Icons.calendar_month_rounded,
                              color: const Color(0xFF6B7280),
                              bg: const Color(0xFFF3F4F6),
                            ),
                            _InfoChip(
                              label: plan.isNoCost
                                  ? '0% interest'
                                  : '${plan.interestRate}% p.a.',
                              icon: plan.isNoCost
                                  ? Icons.percent_rounded
                                  : Icons.trending_up_rounded,
                              color: plan.isNoCost
                                  ? AppColors.emiGreen
                                  : AppColors.warning,
                              bg: plan.isNoCost
                                  ? AppColors.emiGreen
                                      .withValues(alpha: 0.10)
                                  : AppColors.warning
                                      .withValues(alpha: 0.10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Footer: total payable + cashback ──
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.04)
                    : const Color(0xFFF9FAFB),
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10)),
              ),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Row(
                children: [
                  // Total payable
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total payable',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF))),
                        Text(
                          CurrencyFormatter.format(_totalPayable),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cashback
                  if (plan.hasCashback) ...[
                    Container(
                      width: 1,
                      height: 28,
                      color: AppColors.divider,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cashback',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF))),
                        Row(
                          children: [
                            const Icon(Icons.card_giftcard_rounded,
                                size: 12,
                                color: Color(0xFFFBBF24)),
                            const SizedBox(width: 3),
                            Text(
                              CurrencyFormatter.format(plan.cashback),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ],
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

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color, bg;
  const _InfoChip(
      {required this.label,
      required this.icon,
      required this.color,
      required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}
