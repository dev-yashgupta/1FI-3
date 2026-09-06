import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/models/product.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_shimmer.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  static const _categories = ['All', 'Smartphones', 'Audio', 'Laptops'];

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(marketplaceProvider.notifier).loadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filtered(List<Product> products) {
    var list = products;
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  // Responsive column count based on available width
  int _crossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 800)  return 3;
    if (width >= 500)  return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '1Fi Marketplace',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle:
                    const TextStyle(color: Color(0xFFB0B0C0), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFFB0B0C0), size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: Color(0xFFB0B0C0), size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  borderSide:
                      const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Category chips ───────────────────────
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF374151),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 1, color: AppColors.divider),
              ],
            ),
          ),

          // ── Product grid ─────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildBody(state, constraints.maxWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MarketplaceState state, double width) {
    if (state.isLoading) {
      return _LoadingGrid(crossAxisCount: _crossAxisCount(width));
    }

    if (state.hasError) {
      return ErrorView(
        message: state.errorMessage ?? 'Something went wrong.',
        onRetry: () =>
            ref.read(marketplaceProvider.notifier).loadProducts(),
      );
    }

    if (state.isEmpty) {
      return const EmptyView(
        title: 'No products available',
        subtitle: 'Check back soon for exciting deals.',
      );
    }

    final filtered = _filtered(state.products);

    if (filtered.isEmpty) {
      return const EmptyView(
        title: 'No results found',
        subtitle: 'Try a different search or category.',
        icon: Icons.search_off_rounded,
      );
    }

    final cols = _crossAxisCount(width);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () =>
          ref.read(marketplaceProvider.notifier).loadProducts(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // No fixed childAspectRatio — let cards size naturally
          mainAxisExtent: _cardHeight(width, cols),
        ),
        itemCount: filtered.length,
        itemBuilder: (_, i) => ProductCard(product: filtered[i]),
      ),
    );
  }

  /// Compute a safe card height based on available column width.
  double _cardHeight(double gridWidth, int cols) {
    final cardWidth = (gridWidth - 32 - (cols - 1) * 12) / cols;
    final imageHeight = cardWidth / 1.1; // matches AspectRatio(1.1)
    // info area: brand(14) + name(34) + price(18) + mrp(15) + emi(20) + btn(34) + padding(35)
    const infoHeight = 170.0;
    return imageHeight + infoHeight;
  }
}

class _LoadingGrid extends StatelessWidget {
  final int crossAxisCount;
  const _LoadingGrid({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}
