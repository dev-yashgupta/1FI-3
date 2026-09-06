import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero ──────────────────────────────────────
          SliverToBoxAdapter(child: _HeroBanner()),

          // ── OFFERS label ──────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text('OFFERS',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C3CE1),
                      letterSpacing: 1.0)),
            ),
          ),

          // ── Offer carousel ────────────────────────────
          SliverToBoxAdapter(child: _OfferCarousel()),

          // ── SHOP USING 1FI AT TOP BRANDS label ────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text('SHOP USING 1FI AT TOP BRANDS',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C3CE1),
                      letterSpacing: 1.0)),
            ),
          ),

          // ── Brand logo row ────────────────────────────
          SliverToBoxAdapter(child: _BrandLogoRow()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B1FA8), Color(0xFF6C3CE1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GET STARTED label
              const Text('GET STARTED',
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              // Headline
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.3),
                  children: [
                    TextSpan(text: 'Shop on '),
                    TextSpan(
                      text: 'no-cost EMI',
                      style: TextStyle(color: Color(0xFFFBBF24)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Backed by your mutual funds.\nNo credit pull, No charges, & quick approval.',
                style: TextStyle(
                    color: Colors.white70, fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 18),
              // CTA button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  ),
                  child: const Text(
                    'Check eligibility →',
                    style: TextStyle(
                        color: Color(0xFF3B1FA8),
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Offer Carousel ──────────────────────────────────────────────────────────

class _OfferCarousel extends StatefulWidget {
  @override
  State<_OfferCarousel> createState() => _OfferCarouselState();
}

class _OfferCarouselState extends State<_OfferCarousel> {
  int _page = 1;

  static const _offers = [
    _Offer('TRAVEL', 'Fly high with no-cost EMIs', 'Up to 18m no-cost EMIs',
        Color(0xFF0369A1), Icons.flight_rounded),
    _Offer('FURNITURE | MATTRESS | HOME DECOR',
        'Dream homes to sweet dreams', 'Comfort on 12m no-cost EMIs',
        Color(0xFF3B1FA8), Icons.weekend_rounded),
    _Offer('ELECTRONICS', 'Latest gadgets, zero interest',
        'Up to 24m no-cost EMIs', Color(0xFF065F46), Icons.devices_rounded),
    _Offer('FASHION', 'Wear now, pay later', 'Up to 6m no-cost EMIs',
        Color(0xFF9D174D), Icons.checkroom_rounded),
    _Offer('HEALTH & WELLNESS', 'Stay fit, pay easy',
        'Up to 3m no-cost EMIs', Color(0xFF065F46), Icons.favorite_rounded),
    _Offer('EDUCATION', 'Invest in your future', 'Up to 12m no-cost EMIs',
        Color(0xFF1E40AF), Icons.school_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: PageController(initialPage: _page, viewportFraction: 0.88),
            onPageChanged: (p) => setState(() => _page = p),
            itemCount: _offers.length,
            itemBuilder: (_, i) {
              final o = _offers[i];
              return AnimatedScale(
                scale: i == _page ? 1.0 : 0.95,
                duration: AppConstants.animFast,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        o.color,
                        o.color.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.category,
                                style: TextStyle(
                                    color: const Color(0xFFFBBF24),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8)),
                            const SizedBox(height: 6),
                            Text(o.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2)),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.white70, size: 13),
                                const SizedBox(width: 5),
                                Text(o.subtitle,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Icon(o.icon,
                            color: Colors.white.withValues(alpha: 0.15),
                            size: 80),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _offers.length,
            (i) => AnimatedContainer(
              duration: AppConstants.animFast,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _page ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _page
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Offer {
  final String category, title, subtitle;
  final Color color;
  final IconData icon;
  const _Offer(
      this.category, this.title, this.subtitle, this.color, this.icon);
}

// ─── Brand Logo Row ───────────────────────────────────────────────────────────

class _BrandLogoRow extends StatelessWidget {
  static const _logos = [
    _Logo('Goibibo',    Color(0xFF00A7E1), Icons.hotel_rounded),
    _Logo('Wakefit',    Color(0xFF2E7D32), Icons.weekend_rounded),
    _Logo('EaseMyTrip', Color(0xFF1565C0), Icons.flight_rounded),
    _Logo('Yatra',      Color(0xFFE53935), Icons.luggage_rounded),
    _Logo('TAJ',        Color(0xFF4A148C), Icons.business_rounded),
    _Logo('Myntra',     Color(0xFFDB2777), Icons.checkroom_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _logos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final l = _logos[i];
          return Container(
            width: 68,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(l.icon, color: l.color, size: 22),
                const SizedBox(height: 4),
                Text(l.name,
                    style: TextStyle(
                        color: l.color,
                        fontSize: 9,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Logo {
  final String name;
  final Color color;
  final IconData icon;
  const _Logo(this.name, this.color, this.icon);
}
