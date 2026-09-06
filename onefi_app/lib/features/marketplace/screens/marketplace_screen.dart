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

  static const _categories = [
    'All', 'Smartphones', 'Audio', 'Laptops',
  ];

  // Category → icon mapping
  static const _categoryIcons = <String, IconData>{
    'All':         Icons.apps_rounded,
    'Smartphones': Icons.smartphone_rounded,
    'Audio':       Icons.headphones_rounded,
    'Laptops':     Icons.laptop_mac_rounded,
  };

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

  List<Product> _filtered(List<Product> all) {
    var list = all;
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  int _cols(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ───────────────────────────────
          _MarketplaceHeader(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            categories: _categories,
            categoryIcons: _categoryIcons,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            onSearchCleared: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            onCategoryChanged: (c) => setState(() => _selectedCategory = c),
          ),

          // ── Body ─────────────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, box) => _buildBody(state, box.maxWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MarketplaceState state, double width) {
    if (state.isLoading) {
      return _LoadingGrid(cols: _cols(width));
    }
    if (state.hasError) {
      return ErrorView(
        message: state.errorMessage ?? 'Something went wrong.',
        onRetry: () => ref.read(marketplaceProvider.notifier).loadProducts(),
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

    final cols    = _cols(width);
    final hPad    = 16.0;
    final gap     = 12.0;
    final cardW   = (width - hPad * 2 - gap * (cols - 1)) / cols;
    final imgH    = cardW / 1.05;
    // info area: brand + name(2ln) + price + mrp + emi + button + padding
    const infoH   = 168.0;
    final cardH   = imgH + infoH;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.read(marketplaceProvider.notifier).loadProducts(),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          mainAxisExtent: cardH,
        ),
        itemCount: filtered.length,
        itemBuilder: (_, i) => ProductCard(product: filtered[i]),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _MarketplaceHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedCategory;
  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<String> onCategoryChanged;

  const _MarketplaceHeader({
    required this.searchController,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.categoryIcons,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── AppBar row ──────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        size: 18, color: Color(0xFF111827)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      '1Fi Marketplace',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  // Cart icon (decorative)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          color: Color(0xFF374151), size: 24),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Search bar ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search phones, laptops, audio...',
                hintStyle: const TextStyle(
                    color: Color(0xFFB0B0C0), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFFB0B0C0), size: 20),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Color(0xFFB0B0C0), size: 18),
                        onPressed: onSearchCleared,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Category chips ──────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => onCategoryChanged(cat),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoryIcons[cat] ?? Icons.category_rounded,
                          size: 13,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          cat,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF374151),
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

// ─── Loading shimmer grid ─────────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  final int cols;
  const _LoadingGrid({required this.cols});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}
