import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/error_view.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/emi_plan_card.dart';
import '../widgets/variant_selector.dart';
import 'confirmation_sheet.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(productDetailProvider(widget.slug).notifier)
            .loadProduct(widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(state.product?.name ?? 'Product Details'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _buildBody(state),
      bottomNavigationBar: state.isSuccess
          ? _ProceedBar(slug: widget.slug)
          : null,
    );
  }

  Widget _buildBody(ProductDetailState state) {
    if (state.isLoading) return const _DetailShimmer();

    if (state.hasError) {
      final isNotFound = state.errorMessage == 'Product not found';
      return ErrorView(
        message: isNotFound
            ? 'Product not found'
            : (state.errorMessage ?? 'Something went wrong.'),
        onRetry: isNotFound
            ? null
            : () => ref
                .read(productDetailProvider(widget.slug).notifier)
                .loadProduct(widget.slug),
      );
    }

    final product = state.product!;
    final selectedVariant = state.selectedVariant;
    final currentImage =
        selectedVariant?.imageUrl.isNotEmpty == true
            ? selectedVariant!.imageUrl
            : product.imageUrl;
    final currentPrice = selectedVariant?.price ?? product.lowestPrice;
    final currentMrp = selectedVariant?.mrp ?? product.mrp;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product image ────────────────────────
          AnimatedSwitcher(
            duration: AppConstants.animNormal,
            child: AppNetworkImage(
              key: ValueKey(currentImage),
              url: currentImage,
              height: 280,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // ── Product info card ────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Text(product.brand.toUpperCase(),
                    style: AppTextStyles.overline),
                const SizedBox(height: 4),
                // Name
                Text(product.name, style: AppTextStyles.displayMedium),
                const SizedBox(height: 4),
                // Variant subtitle
                if (selectedVariant != null)
                  Text(
                    '${selectedVariant.storage} · ${selectedVariant.color}',
                    style: AppTextStyles.bodySmall,
                  ),
                const SizedBox(height: 12),

                // Price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(CurrencyFormatter.format(currentPrice),
                        style: AppTextStyles.priceMain),
                    const SizedBox(width: 10),
                    if (currentMrp > currentPrice) ...[
                      Text(CurrencyFormatter.format(currentMrp),
                          style: AppTextStyles.priceMrp),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                        ),
                        child: Text(
                          '${product.discountPercent}% off',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Rating
                if (product.rating > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                            i < product.rating.floor()
                                ? Icons.star_rounded
                                : i < product.rating
                                    ? Icons.star_half_rounded
                                    : Icons.star_border_rounded,
                            size: 16,
                            color: AppColors.accent,
                          )),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Variant selector ─────────────────────
          if (product.variants.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose Variant', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 16),
                  VariantSelector(
                    product: product,
                    selected: selectedVariant,
                    onChanged: (v) => ref
                        .read(productDetailProvider(widget.slug).notifier)
                        .selectVariant(v),
                  ),
                ],
              ),
            ),

          // ── Description ──────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                Text(product.description, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),

          // ── EMI plans ────────────────────────────
          if (product.emiPlans.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('EMI Plans', style: AppTextStyles.headlineSmall),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emiBadge.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusPill),
                        ),
                        child: const Text(
                          'No-cost available',
                          style: TextStyle(
                            color: AppColors.emiBadge,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Select a plan to proceed',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 16),
                  ...product.emiPlans.map((plan) => EmiPlanCard(
                        plan: plan,
                        isSelected:
                            state.selectedEmiPlan?.id == plan.id,
                        onTap: () => ref
                            .read(productDetailProvider(widget.slug)
                                .notifier)
                            .selectEmiPlan(plan),
                      )),
                ],
              ),
            ),

          // bottom padding for FAB
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─── Proceed bar ─────────────────────────────────────────────────────────────

class _ProceedBar extends ConsumerWidget {
  final String slug;
  const _ProceedBar({required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(slug));
    final canProceed = state.canProceed;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!canProceed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Select a variant and EMI plan to proceed',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          AppButton(
            label: 'Proceed with Selected Plan',
            onPressed: canProceed
                ? () => showConfirmationSheet(context, state)
                : null,
          ),
        ],
      ),
    );
  }
}

// ─── Loading shimmer ─────────────────────────────────────────────────────────

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 280, color: AppColors.shimmerBase),
          const SizedBox(height: 16),
          _shimmerBox(margin: 16, height: 120),
          _shimmerBox(margin: 16, height: 160),
          _shimmerBox(margin: 16, height: 260),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double margin, required double height}) {
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, margin, 16),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      ),
    );
  }
}
