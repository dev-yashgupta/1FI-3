import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tc =
      TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    // When user taps "1Fi Marketplace" tab (index 2), navigate directly
    _tc.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Only trigger on actual tap (not animation frames)
    if (_tc.indexIsChanging && _tc.index == 2) {
      // Reset back to previous tab before navigating so the tab bar
      // doesn't show "1Fi Marketplace" as selected when user comes back
      Future.microtask(() {
        if (mounted) {
          _tc.animateTo(_tc.previousIndex);
          context.push('/marketplace');
        }
      });
    }
  }

  @override
  void dispose() {
    _tc.removeListener(_onTabChanged);
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Hero banner ──────────────────────────────
          _HeroBanner(tabController: _tc),
          // ── Body tabs ────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tc,
              children: const [
                _TopBrandsTab(),
                _NearbyStoresTab(),
                _MarketplaceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Banner + Pill Tab Bar ───────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final TabController tabController;
  const _HeroBanner({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B1FA8), Color(0xFF6C3CE1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // content row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Text side ──────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NO-COST EMIs badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.auto_awesome_rounded,
                                  color: Color(0xFFFBBF24), size: 11),
                              SizedBox(width: 5),
                              Text('NO-COST EMIs',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Headline
                        const Text(
                          'Shop today,',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.15),
                        ),
                        const Text(
                          'Pay later using',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              height: 1.15),
                        ),
                        const Text(
                          'Mutual funds.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.15),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No credit score required. No interest.\nBacked by your investments.',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.5,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  // ── Illustration ────────────────────
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // shopping bag
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 70,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // phone
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(Icons.smartphone_rounded,
                              color: Colors.white, size: 44),
                        ),
                        // laptop
                        Positioned(
                          top: 10,
                          left: 0,
                          child: Icon(Icons.laptop_rounded,
                              color: Colors.white.withValues(alpha: 0.85),
                              size: 36),
                        ),
                        // car icon
                        Positioned(
                          bottom: 20,
                          left: 0,
                          child: Icon(Icons.directions_car_rounded,
                              color: const Color(0xFFEF4444), size: 28),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Pill tab switcher ─────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
              child: TabBar(
                controller: tabController,
                isScrollable: false,
                labelColor: AppColors.tabSelected,
                unselectedLabelColor: AppColors.tabUnselected,
                labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 6,
                        offset: Offset(0, 1)),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Top Brands'),
                  Tab(text: 'Nearby Stores'),
                  Tab(text: '1Fi Marketplace'),
                ],
              ),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}

// ─── Top Brands Tab ───────────────────────────────────────────────────────────

class _TopBrandsTab extends StatefulWidget {
  const _TopBrandsTab();
  @override
  State<_TopBrandsTab> createState() => _TopBrandsTabState();
}

class _TopBrandsTabState extends State<_TopBrandsTab> {
  final _searchController = TextEditingController();

  static const _brands = [
    _BrandItem('Air India', 'No-cost EMIs upto 18 months', Color(0xFFE53935), Icons.flight_rounded),
    _BrandItem('Apple Premium Reseller', 'No-cost EMIs upto 24 months', Color(0xFF1C1C1E), Icons.apple_rounded),
    _BrandItem('Croma', 'No-cost EMIs upto 18 months', Color(0xFF2563EB), Icons.tv_rounded),
    _BrandItem('Flipkart', 'No-cost EMIs upto 12 months', Color(0xFFF59E0B), Icons.shopping_bag_rounded),
    _BrandItem('Myntra', 'No-cost EMIs upto 6 months', Color(0xFFDB2777), Icons.checkroom_rounded),
    _BrandItem('Nykaa Fashion', 'No-cost EMIs upto 6 months', Color(0xFFEC4899), Icons.spa_rounded),
    _BrandItem('P&G', 'No-cost EMIs upto 3 months', Color(0xFF0369A1), Icons.cleaning_services_rounded),
    _BrandItem('Boat Lifestyle', 'No-cost EMIs upto 12 months', Color(0xFF111827), Icons.headphones_rounded),
    _BrandItem('Goibibo', 'No-cost EMIs upto 12 months', Color(0xFF00A7E1), Icons.hotel_rounded),
    _BrandItem('Adidas Rent', 'No-cost EMIs upto 6 months', Color(0xFF374151), Icons.sports_soccer_rounded),
    _BrandItem('JM Abicor Binzel', 'No-cost EMIs upto 12 months', Color(0xFF1D4ED8), Icons.build_rounded),
    _BrandItem('Jumbotail Mart B2B', 'No-cost EMIs upto 6 months', Color(0xFF059669), Icons.store_rounded),
    _BrandItem('Kaison Gemfield', 'No-cost EMIs upto 6 months', Color(0xFF7C3AED), Icons.diamond_rounded),
    _BrandItem('Kaison Gemfield', 'No-cost EMIs upto 6 months', Color(0xFF7C3AED), Icons.diamond_rounded),
    _BrandItem('Plum Color', 'No-cost EMIs upto 3 months', Color(0xFFA855F7), Icons.palette_rounded),
    _BrandItem('Plum Makeup', 'No-cost EMIs upto 3 months', Color(0xFFA855F7), Icons.face_rounded),
    _BrandItem('Pluches', 'No-cost EMIs upto 3 months', Color(0xFF0EA5E9), Icons.child_care_rounded),
    _BrandItem('Vivid', 'No-cost EMIs upto 6 months', Color(0xFFEF4444), Icons.color_lens_rounded),
    _BrandItem('1Fi Global Membership', 'No-cost EMIs upto 12 months', Color(0xFF6C3CE1), Icons.star_rounded),
    _BrandItem('Fultro', 'No-cost EMIs upto 6 months', Color(0xFF0891B2), Icons.water_drop_rounded),
    _BrandItem('Farmako', 'No-cost EMIs upto 3 months', Color(0xFF16A34A), Icons.local_pharmacy_rounded),
    _BrandItem('Tasahna', 'No-cost EMIs upto 3 months', Color(0xFFB45309), Icons.restaurant_rounded),
    _BrandItem('S.I.G.', 'No-cost EMIs upto 6 months', Color(0xFF374151), Icons.business_rounded),
    _BrandItem('Vardhaa', 'No-cost EMIs upto 6 months', Color(0xFF7E22CE), Icons.auto_awesome_rounded),
    _BrandItem('Geetanjali Salon', 'No-cost EMIs upto 6 months', Color(0xFFDB2777), Icons.content_cut_rounded),
    _BrandItem('Mankind Goodaid', 'No-cost EMIs upto 3 months', Color(0xFF0369A1), Icons.medical_services_rounded),
    _BrandItem('Your Paro', 'No-cost EMIs upto 3 months', Color(0xFFEC4899), Icons.favorite_rounded),
    _BrandItem('Yandis', 'No-cost EMIs upto 3 months', Color(0xFF059669), Icons.shopping_cart_rounded),
    _BrandItem('Whistler Gun', 'No-cost EMIs upto 6 months', Color(0xFF374151), Icons.sports_handball_rounded),
    _BrandItem('Tata Fruits & Veggies', 'No-cost EMIs upto 3 months', Color(0xFF0D9488), Icons.eco_rounded),
  ];

  List<_BrandItem> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _brands;
    return _brands.where((b) => b.name.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search online stores...',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppColors.textHint, size: 20),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                borderSide:
                    BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        // List header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Top Brands',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
        ),
        // Brand list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: _filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (_, i) => _BrandCard(brand: _filtered[i]),
          ),
        ),
      ],
    );
  }
}

class _BrandCard extends StatelessWidget {
  final _BrandItem brand;
  const _BrandCard({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Brand logo
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: brand.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(brand.icon, color: brand.color, size: 26),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 3),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5),
                    children: [
                      const TextSpan(
                          text: 'No-cost ',
                          style: TextStyle(color: Color(0xFF6B7280))),
                      TextSpan(
                          text: 'EMIs',
                          style:
                              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: ' upto 18 months',
                          style: const TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

class _BrandItem {
  final String name, subtitle;
  final Color color;
  final IconData icon;
  const _BrandItem(this.name, this.subtitle, this.color, this.icon);
}

// ─── Nearby Stores Tab ────────────────────────────────────────────────────────

class _NearbyStoresTab extends StatelessWidget {
  const _NearbyStoresTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search nearby stores...',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppColors.textHint, size: 20),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                borderSide: BorderSide(color: AppColors.divider),
              ),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined,
                    size: 64, color: Color(0xFFD1D5DB)),
                SizedBox(height: 16),
                Text('Nearby Stores',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151))),
                SizedBox(height: 6),
                Text('No stores found near you',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 1Fi Marketplace Tab ──────────────────────────────────────────────────────

class _MarketplaceTab extends StatelessWidget {
  const _MarketplaceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          // CTA card
          GestureDetector(
            onTap: () => context.push('/marketplace'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B1FA8), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('NEW',
                              style: TextStyle(
                                  color: Color(0xFF1C1917),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1)),
                        ),
                        const SizedBox(height: 10),
                        const Text('1Fi Marketplace',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        const Text(
                          'Browse phones, laptops & more.\nPay with no-cost EMI.',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.45),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Explore Now →',
                              style: TextStyle(
                                  color: Color(0xFF3B1FA8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    children: [
                      Icon(Icons.smartphone_rounded,
                          color: Colors.white, size: 44),
                      SizedBox(height: 8),
                      Icon(Icons.headphones_rounded,
                          color: Colors.white70, size: 36),
                      SizedBox(height: 8),
                      Icon(Icons.laptop_mac_rounded,
                          color: Colors.white54, size: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Feature chips
          const Text('WHY SHOP WITH 1FI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6C3CE1),
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Row(children: const [
            Expanded(child: _FeatChip(Icons.percent_rounded, 'No-cost EMI')),
            SizedBox(width: 10),
            Expanded(child: _FeatChip(Icons.credit_score_rounded, 'No credit check')),
          ]),
          const SizedBox(height: 10),
          Row(children: const [
            Expanded(child: _FeatChip(Icons.bolt_rounded, 'Instant approval')),
            SizedBox(width: 10),
            Expanded(child: _FeatChip(Icons.account_balance_outlined, 'Backed by MF')),
          ]),
        ],
      ),
    );
  }
}

class _FeatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 17),
          const SizedBox(width: 7),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
