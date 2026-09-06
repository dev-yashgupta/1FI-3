import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
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
      appBar: _buildAppBar(state),
      body: _buildBody(state),
      bottomNavigationBar:
          state.isSuccess ? _ProceedBar(slug: widget.slug) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(ProductDetailState state) {
    return AppBar(
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
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined,
              size: 20, color: Color(0xFF374151)),
          onPressed: () {},
          tooltip: 'Share',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.divider),
      ),
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
    final savings      = currentMrp - currentPrice;

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
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: child,
              ),
              child: AppNetworkImage(
                key: ValueKey(currentImage),
                url: currentImage,
                width: double.infinity,
                height: 260,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Thumbnail strip for variants with different images
          if (product.variants.length > 1)
            _ThumbnailStrip(
              product: product,
              selected: selectedVariant,
              onTap: (v) => ref
                  .read(productDetailProvider(widget.slug).notifier)
                  .selectVariant(v),
            ),

          // ── 2. Product info card ──────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand + category row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
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
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
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
                        fontSize: 24,
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

                // Savings callout
                if (savings > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.savings_outlined,
                          size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        'You save ${CurrencyFormatter.format(savings)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],

                // Rating
                if (product.rating > 0) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        if (i < product.rating.floor()) {
                          return const Icon(Icons.star_rounded,
                              size: 16, color: Color(0xFFFBBF24));
                        } else if (i < product.rating) {
                          return const Icon(Icons.star_half_rounded,
                              size: 16, color: Color(0xFFFBBF24));
                        }
                        return const Icon(Icons.star_border_rounded,
                            size: 16, color: Color(0xFFD1D5DB));
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount} reviews)',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── 3. Delivery + highlights strip ───────
          _Card(
            child: Row(
              children: const [
                Expanded(
                    child: _HighlightChip(
                        Icons.local_shipping_outlined,
                        'Free delivery',
                        Color(0xFF0284C7))),
                SizedBox(width: 8),
                Expanded(
                    child: _HighlightChip(
                        Icons.verified_outlined,
                        'Genuine product',
                        Color(0xFF059669))),
                SizedBox(width: 8),
                Expanded(
                    child: _HighlightChip(
                        Icons.replay_rounded,
                        '7-day return',
                        Color(0xFF7C3AED))),
              ],
            ),
          ),

          // ── 4. Variant selector ───────────────────
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

          // ── 5. Description ────────────────────────
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
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF374151),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // ── 6. EMI Plans ──────────────────────────
          if (product.emiPlans.isNotEmpty)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EMI Plans',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827))),
                            SizedBox(height: 2),
                            Text('Tap a plan to select',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emiGreen
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt_rounded,
                                size: 12,
                                color: AppColors.emiGreen),
                            SizedBox(width: 3),
                            Text(
                              'No-cost available',
                              style: TextStyle(
                                color: AppColors.emiGreen,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...product.emiPlans.map((plan) {
                    final isSelected =
                        ref.watch(productDetailProvider(widget.slug))
                                .selectedEmiPlan
                                ?.id ==
                            plan.id;
                    return EmiPlanCard(
                      plan: plan,
                      isSelected: isSelected,
                      onTap: () => ref
                          .read(productDetailProvider(widget.slug)
                              .notifier)
                          .selectEmiPlan(plan),
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─── Thumbnail strip ──────────────────────────────────────────────────────────

class _ThumbnailStrip extends StatelessWidget {
  final dynamic product;
  final dynamic selected;
  final ValueChanged<dynamic> onTap;

  const _ThumbnailStrip({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final variants = product.variants as List;
    if (variants.length <= 1) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: variants.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final v = variants[i];
          final isActive = v.id == selected?.id;
          return GestureDetector(
            onTap: () => onTap(v),
            child: AnimatedContainer(
              duration: AppConstants.animFast,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.border,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  v.imageUrl as String,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Container(
                    color: AppColors.background,
                    child: const Icon(Icons.image_outlined,
                        size: 18, color: AppColors.textHint),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Highlight chip ───────────────────────────────────────────────────────────

class _HighlightChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _HighlightChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
    final plan       = state.selectedEmiPlan;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
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
          // Selected plan summary or prompt
          if (canProceed && plan != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${CurrencyFormatter.formatMonthly(plan.monthlyAmount)} '
                      '× ${plan.tenureMonths} months'
                      '${plan.isNoCost ? " · 0% interest" : ""}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (!canProceed)
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
          // CTA button
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
                disabledForegroundColor:
                    Colors.white.withValues(alpha: 0.5),
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

// ─── Detail shimmer ───────────────────────────────────────────────────────────

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 260, color: AppColors.shimmerBase),
          const SizedBox(height: 12),
          _box(16, 140),
          _box(16, 80),
          _box(16, 120),
          _box(16, 90),
          _box(16, 280),
        ],
      ),
    );
  }

  Widget _box(double m, double h) => Container(
        margin: EdgeInsets.fromLTRB(m, 0, m, 12),
        height: h,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(16),
        ),
      );
}
