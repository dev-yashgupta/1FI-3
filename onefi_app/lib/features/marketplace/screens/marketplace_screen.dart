import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
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
  String  _searchQuery      = '';
  String  _selectedCategory = 'All';
  bool    _isGridView       = true;
  String  _sortBy           = 'default';

  static const _categories = ['All', 'Smartphones', 'Audio', 'Laptops'];
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
    var list = [...all];
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q)).toList();
    }
    switch (_sortBy) {
      case 'price_asc':
        list.sort((a, b) => a.lowestPrice.compareTo(b.lowestPrice));
      case 'price_desc':
        list.sort((a, b) => b.lowestPrice.compareTo(a.lowestPrice));
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'discount':
        list.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    }
    return list;
  }

  int _cols(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SortSheet(
        current: _sortBy,
        onSelected: (v) => setState(() => _sortBy = v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _MarketplaceHeader(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            categories: _categories,
            categoryIcons: _categoryIcons,
            isGridView: _isGridView,
            sortBy: _sortBy,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            onSearchCleared: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            onCategoryChanged: (c) => setState(() => _selectedCategory = c),
            onToggleView: () => setState(() => _isGridView = !_isGridView),
            onSort: _showSortSheet,
          ),
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
    if (state.isLoading) return _LoadingGrid(cols: _cols(width));

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

    final cols  = _cols(width);
    final hPad  = 16.0;
    final gap   = 12.0;
    final cardW = (width - hPad * 2 - gap * (cols - 1)) / cols;
    final imgH  = cardW / 1.05;
    const infoH = 168.0;
    final cardH = imgH + infoH;

    // ── Result count bar ──────────────────────────
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Text(
                '${filtered.length} product${filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              if (_sortBy != 'default')
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _sortLabel(_sortBy),
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => _sortBy = 'default'),
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.primary, size: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.divider),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                ref.read(marketplaceProvider.notifier).loadProducts(),
            child: _isGridView
                ? GridView.builder(
                    padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: gap,
                      mainAxisSpacing: gap,
                      mainAxisExtent: cardH,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        ProductCard(product: filtered[i]),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        ProductListTile(product: filtered[i]),
                  ),
          ),
        ),
      ],
    );
  }

  String _sortLabel(String key) {
    return switch (key) {
      'price_asc'  => 'Price: Low to High',
      'price_desc' => 'Price: High to Low',
      'rating'     => 'Top Rated',
      'discount'   => 'Best Discount',
      _            => '',
    };
  }
}

// ─── Sort bottom sheet ────────────────────────────────────────────────────────

class _SortSheet extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelected;

  const _SortSheet({required this.current, required this.onSelected});

  static const _options = [
    ('default',    'Relevance',            Icons.sort_rounded),
    ('price_asc',  'Price: Low to High',   Icons.arrow_upward_rounded),
    ('price_desc', 'Price: High to Low',   Icons.arrow_downward_rounded),
    ('rating',     'Top Rated',            Icons.star_rounded),
    ('discount',   'Best Discount',        Icons.local_offer_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Sort By',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: Color(0xFF111827))),
          const SizedBox(height: 12),
          ..._options.map((opt) {
            final isActive = opt.$1 == current;
            return InkWell(
              onTap: () {
                onSelected(opt.$1);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 13),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(opt.$3,
                        size: 18,
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFF6B7280)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(opt.$2,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isActive
                                  ? AppColors.primary
                                  : const Color(0xFF374151))),
                    ),
                    if (isActive)
                      const Icon(Icons.check_rounded,
                          color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _MarketplaceHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery, selectedCategory, sortBy;
  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final bool isGridView;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared, onToggleView, onSort;
  final ValueChanged<String> onCategoryChanged;

  const _MarketplaceHeader({
    required this.searchController,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.categoryIcons,
    required this.isGridView,
    required this.sortBy,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onCategoryChanged,
    required this.onToggleView,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // ── AppBar row ───────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        size: 18, color: Color(0xFF111827)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1Fi Marketplace',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827))),
                        Text('Shop on No-cost EMI',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                  // Sort button
                  IconButton(
                    onPressed: onSort,
                    tooltip: 'Sort',
                    icon: Icon(
                      Icons.sort_rounded,
                      size: 22,
                      color: sortBy != 'default'
                          ? AppColors.primary
                          : const Color(0xFF374151),
                    ),
                  ),
                  // Grid/List toggle
                  IconButton(
                    onPressed: onToggleView,
                    tooltip: isGridView ? 'List view' : 'Grid view',
                    icon: Icon(
                      isGridView
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      size: 22,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Search bar ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                  borderSide:
                      const BorderSide(color: Color(0xFFE5E7EB)),
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

          // ── Category chips ───────────────────────
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat      = categories[i];
                final isActive = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => onCategoryChanged(cat),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoryIcons[cat] ??
                              Icons.category_rounded,
                          size: 13,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          cat,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF374151),
                            fontSize: 12,
                            fontWeight: isActive
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

// ─── List tile view (alternative to grid) ────────────────────────────────────

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final emi = product.shortestEmiPlan;
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed('/marketplace/${product.slug}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 96,
                height: 96,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Container(
                    color: AppColors.background,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textHint),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.6)),
                  const SizedBox(height: 2),
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(product.lowestPrice),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary),
                      ),
                      if (product.mrp > product.lowestPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(product.mrp),
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Color(0xFF9CA3AF)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success
                                .withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercent}% off',
                            style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (emi != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.credit_card_rounded,
                            size: 11,
                            color: AppColors.emiGreen),
                        const SizedBox(width: 4),
                        Text(
                          'EMI from ${CurrencyFormatter.formatMonthly(emi.monthlyAmount)}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.emiGreen,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                  // Stars
                  if (product.rating > 0) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (i) => Icon(
                                  i < product.rating.floor()
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 12,
                                  color: const Color(0xFFFBBF24),
                                )),
                        const SizedBox(width: 4),
                        Text('${product.rating}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280))),
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

// ─── Loading shimmer grid ─────────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  final int cols;
  const _LoadingGrid({required this.cols});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const hPad  = 16.0;
        const gap   = 12.0;
        final cardW = (width - hPad * 2 - gap * (cols - 1)) / cols;
        final imgH  = cardW / 1.05;
        const infoH = 168.0;
        final cardH = imgH + infoH;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            mainAxisExtent: cardH,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const ProductCardShimmer(),
        );
      },
    );
  }
}
