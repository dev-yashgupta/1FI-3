import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../providers/marketplace_provider.dart';

void showConfirmationSheet(
    BuildContext context, ProductDetailState state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => _ConfirmationSheet(state: state),
  );
}

class _ConfirmationSheet extends StatefulWidget {
  final ProductDetailState state;
  const _ConfirmationSheet({required this.state});

  @override
  State<_ConfirmationSheet> createState() => _ConfirmationSheetState();
}

class _ConfirmationSheetState extends State<_ConfirmationSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  late final Animation<double> _scale = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.elasticOut,
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.state.product!;
    final variant = widget.state.selectedVariant!;
    final plan    = widget.state.selectedEmiPlan!;
    final savings = (variant.mrp > variant.price)
        ? variant.mrp - variant.price
        : 0.0;
    final totalPayable = plan.monthlyAmount * plan.tenureMonths;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 12, 24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Animated check icon
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 38,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Plan Selected!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Review your selection before proceeding',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 20),

          // ── Summary card ──────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _SummaryRow(
                    icon: Icons.smartphone_rounded,
                    label: 'Product',
                    value: product.name),
                _divider(),
                _SummaryRow(
                    icon: Icons.tune_rounded,
                    label: 'Variant',
                    value:
                        '${variant.storage} · ${variant.color}'),
                _divider(),
                _SummaryRow(
                    icon: Icons.calendar_month_rounded,
                    label: 'Monthly EMI',
                    value: CurrencyFormatter.formatPerMonth(
                        plan.monthlyAmount),
                    highlight: true),
                _divider(),
                _SummaryRow(
                    icon: Icons.access_time_rounded,
                    label: 'Tenure',
                    value: '${plan.tenureMonths} months'),
                _divider(),
                _SummaryRow(
                    icon: Icons.percent_rounded,
                    label: 'Interest',
                    value: plan.isNoCost
                        ? '0% (No-cost EMI)'
                        : '${plan.interestRate}% p.a.',
                    valueColor: plan.isNoCost
                        ? AppColors.emiGreen
                        : AppColors.warning),
                _divider(),
                _SummaryRow(
                    icon: Icons.receipt_long_rounded,
                    label: 'Total payable',
                    value: CurrencyFormatter.format(totalPayable)),
                if (plan.hasCashback) ...[
                  _divider(),
                  _SummaryRow(
                      icon: Icons.card_giftcard_rounded,
                      label: 'Cashback',
                      value: CurrencyFormatter.format(plan.cashback),
                      valueColor: const Color(0xFFD97706)),
                ],
                if (savings > 0) ...[
                  _divider(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.06),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.savings_rounded,
                            color: AppColors.success, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'You save ${CurrencyFormatter.format(savings)} on this order',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Continue CTA
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccess(context, product.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continue',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Change Plan',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16);

  void _showSuccess(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'EMI plan confirmed for $name!',
                style: const TextStyle(fontWeight: FontWeight.w600),
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

// ─── Summary row ──────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool highlight;
  final Color? valueColor;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: const Color(0xFF6B7280))),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: highlight
                  ? const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)
                  : TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? const Color(0xFF111827)),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
