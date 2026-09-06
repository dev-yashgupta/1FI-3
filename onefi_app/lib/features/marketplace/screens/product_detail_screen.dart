import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
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

class _ProductDetailScreenState
    extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(productDetailProvider(widget.slug).notifier)
        .loadProduct(widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              size: 18, color: Color(0xFF111827)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          state.product?.name ?? 'Product Details',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
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
      final notFound = state.errorMessage == 'Product not found';
      return ErrorView(
        message: state.errorMessage ?? 'Something went wrong.',
        onRetry: notFound
            ? null
            : () => ref
                .read(productDetailProvider(widget.slug).notifier)
                .loadProduct(widget.slug),
      );
    }

    final product         = state.product!;
    final selectedVariant = state.selectedVariant;
    final currentImage    = (selectedVariant?.imageUrl.isNotEmpty == true)
        ? selectedVariant!.imageUrl
        : product.imageUrl;
    final currentPrice = selectedVariant?.price ?? product.lowestPrice;
    final currentMrp   = selectedVariant?.mrp   ?? product.mrp;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── 1. Product image ─────────────────────
          Container(
            color: AppColors.surface,
            width: double.infinity,
            height: 260,
            child: AnimatedSwitcher(
              duration: AppConstants.animNormal,
              child: AppNetworkImage(
                key: ValueKey(currentImage),
                url: currentImage,
                width: double.infinity,
                height: 260,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ── 2. Product info card ──────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.brand.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        height: 1.2)),
                // Variant subtitle
                if (selectedVariant != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${selectedVariant.storage} · ${selectedVariant.color}',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
                const SizedBox(height: 12),
                // Price row
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      CurrencyFormatter.format(currentPrice),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    if (currentMrp > currentPrice) ...[
                      Text(
                        CurrencyFormatter.format(currentMrp),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Color(0xFF9CA3AF),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(6),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        if (i < product.rating.floor()) {
                          return const Icon(Icons.star_rounded,
                              size: 15, color: Color(0xFFFBBF24));
                        } else if (i < product.rating) {
                          return const Icon(Icons.star_half_rounded,
                              size: 15, color: Color(0xFFFBBF24));
                        } else {
                          return const Icon(Icons.star_border_rounded,
                              size: 15, color: Color(0xFFD1D5DB));
                        }
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating}  (${product.reviewCount} reviews)',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── 3. Variant selector ───────────────────
          if (product.variants.isNotEmpty)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose Variant',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                  const SizedBox(height: 14),
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

          // ── 4. Description ────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('About this product',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
                const SizedBox(height: 8),
                Text(product.description,
                    style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF374151),
                        height: 1.6)),
              ],
            ),
          ),

          // ── 5. EMI Plans ──────────────────────────
          if (product.emiPlans.isNotEmpty)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('EMI Plans',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emiGreen.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'No-cost available',
                          style: TextStyle(
                            color: AppColors.emiGreen,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a plan to enable Proceed',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 14),
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

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─── Card wrapper ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}

// ─── Proceed bar ──────────────────────────────────────────────────────────────

class _ProceedBar extends ConsumerWidget {
  final String slug;
  const _ProceedBar({required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state      = ref.watch(productDetailProvider(slug));
    final canProceed = state.canProceed;
    final bottomPad  = MediaQuery.of(context).padding.bottom;

    return Container(
      padding:
          EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
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
                state.selectedVariant == null
                    ? 'Select a variant to continue'
                    : 'Select an EMI plan to continue',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () => showConfirmationSheet(context, state)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed
                    ? AppColors.primary
                    : AppColors.border,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Proceed with Selected Plan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading shimmer ──────────────────────────────────────────────────────────

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 260,
              color: AppColors.shimmerBase),
          const SizedBox(height: 12),
          _shimmer(margin: 16, height: 130),
          _shimmer(margin: 16, height: 100),
          _shimmer(margin: 16, height: 80),
          _shimmer(margin: 16, height: 260),
        ],
      ),
    );
  }

  Widget _shimmer({required double margin, required double height}) {
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, margin, 12),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
