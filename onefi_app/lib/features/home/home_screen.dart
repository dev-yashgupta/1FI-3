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
          // ── 1. Hero banner ────────────────────────
          SliverToBoxAdapter(child: _HeroBanner()),

          // ── 2. OFFERS label + carousel ────────────
          const SliverToBoxAdapter(child: _SectionLabel('OFFERS')),
          SliverToBoxAdapter(child: _OffersCarousel()),

          // ── 3. SHOP USING 1FI AT TOP BRANDS ───────
          const SliverToBoxAdapter(
              child: _SectionLabel('SHOP USING 1FI AT TOP BRANDS')),
          SliverToBoxAdapter(child: _BrandLogoRow()),

          // ── 4. Feature chips ──────────────────────
          SliverToBoxAdapter(child: _FeatureChipsGrid()),

          // ── 5. HOW 1FI WORKS ──────────────────────
          const SliverToBoxAdapter(
              child: _SectionLabel('HOW 1FI WORKS')),
          SliverToBoxAdapter(child: _HowItWorks()),

          // ── 6. Refer & Earn banner ────────────────
          SliverToBoxAdapter(child: _ReferEarnBanner()),

          // ── 7. FAQ ────────────────────────────────
          const SliverToBoxAdapter(
              child: _SectionLabel('FREQUENTLY ASKED QUESTIONS')),
          SliverToBoxAdapter(child: _FaqSection()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 1. Hero Banner ───────────────────────────────────────────────────────────

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left text
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(text: 'Shop on '),
                          TextSpan(
                            text: 'no-cost EMI',
                            style: TextStyle(color: Color(0xFFFBBF24)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Backed by your mutual funds, No\ncredit pull, No charges, & quick\napproval.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusPill),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Check eligibility',
                              style: TextStyle(
                                color: Color(0xFF3B1FA8),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded,
                                color: Color(0xFF3B1FA8), size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right — 0% INTEREST badge
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '0%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const Text(
                            'INTEREST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Decorative coin
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFBBF24),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFCD34D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 2. Offers Carousel ───────────────────────────────────────────────────────

class _OffersCarousel extends StatefulWidget {
  @override
  State<_OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<_OffersCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _page = 0;

  static const _offers = [
    _OfferItem(
      category: 'APPLE FLAGSHIP DEAL',
      title: 'Upgrade to iPhone 17 Pro\nwith Easy EMIs',
      subtitle: 'Upto 24m no cost EMI',
      gradientColors: [Color(0xFF7C2D12), Color(0xFF92400E)],
      icon: Icons.smartphone_rounded,
    ),
    _OfferItem(
      category: 'FURNITURE | MATTRESS | HOME DECOR',
      title: 'Dream homes to\nsweet dreams',
      subtitle: 'Comfort on 12m no-cost EMIs',
      gradientColors: [Color(0xFF3B1FA8), Color(0xFF6C3CE1)],
      icon: Icons.weekend_rounded,
    ),
    _OfferItem(
      category: 'ELECTRONICS',
      title: 'Latest gadgets,\nzero interest',
      subtitle: 'Upto 24m no-cost EMIs',
      gradientColors: [Color(0xFF065F46), Color(0xFF047857)],
      icon: Icons.devices_rounded,
    ),
    _OfferItem(
      category: 'TRAVEL',
      title: 'Fly high with\nno-cost EMIs',
      subtitle: 'Upto 18m no-cost EMIs',
      gradientColors: [Color(0xFF0369A1), Color(0xFF0284C7)],
      icon: Icons.flight_rounded,
    ),
    _OfferItem(
      category: 'FASHION',
      title: 'Wear now,\npay later',
      subtitle: 'Upto 6m no-cost EMIs',
      gradientColors: [Color(0xFF9D174D), Color(0xFFBE185D)],
      icon: Icons.checkroom_rounded,
    ),
    _OfferItem(
      category: 'EDUCATION',
      title: 'Invest in your\nfuture',
      subtitle: 'Upto 12m no-cost EMIs',
      gradientColors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
      icon: Icons.school_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _controller,
            itemCount: _offers.length,
            onPageChanged: (p) => setState(() => _page = p),
            itemBuilder: (_, i) {
              final o = _offers[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: o.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    // bg icon watermark
                    Positioned(
                      right: -10,
                      top: -10,
                      child: Icon(
                        o.icon,
                        size: 130,
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.category,
                            style: const TextStyle(
                              color: Color(0xFFFBBF24),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            o.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.white60, size: 13),
                              const SizedBox(width: 5),
                              Text(
                                o.subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
              width: i == _page ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _page ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferItem {
  final String category, title, subtitle;
  final List<Color> gradientColors;
  final IconData icon;
  const _OfferItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}

// ─── 3. Brand Logo Row ────────────────────────────────────────────────────────

class _BrandLogoRow extends StatelessWidget {
  static const _logos = [
    _Logo('Croma',       Color(0xFF15803D), Icons.tv_rounded),
    _Logo('Vijay Sales', Color(0xFFDC2626), Icons.storefront_rounded),
    _Logo('MakeMyTrip',  Color(0xFFEA580C), Icons.flight_rounded),
    _Logo('Air India',   Color(0xFFDC2626), Icons.airlines_rounded),
    _Logo('Goibibo',     Color(0xFF0284C7), Icons.hotel_rounded),
    _Logo('Wakefit',     Color(0xFF15803D), Icons.weekend_rounded),
    _Logo('Myntra',      Color(0xFFDB2777), Icons.checkroom_rounded),
    _Logo('EaseMyTrip',  Color(0xFFEA580C), Icons.luggage_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _logos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final l = _logos[i];
          return Container(
            width: 72,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(l.icon, color: l.color, size: 22),
                const SizedBox(height: 5),
                Text(
                  l.name,
                  style: TextStyle(
                    color: l.color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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

// ─── 4. Feature Chips Grid ────────────────────────────────────────────────────

class _FeatureChipsGrid extends StatelessWidget {
  static const _chips = [
    _Chip(Icons.trending_up_rounded,   'Keep growing',       'No tax, no exit load.'),
    _Chip(Icons.percent_rounded,       '0% interest',        'Repay only what you spend.'),
    _Chip(Icons.bolt_rounded,          'Quickest approvals', 'Instant eligibility check.'),
    _Chip(Icons.money_off_rounded,     'Zero charges',       'No fees, nothing hidden.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _chips.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
        ),
        itemBuilder: (_, i) {
          final c = _chips[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(c.icon, color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        c.subtitle,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF9CA3AF),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Chip {
  final IconData icon;
  final String title, subtitle;
  const _Chip(this.icon, this.title, this.subtitle);
}

// ─── 5. How 1Fi Works ─────────────────────────────────────────────────────────

class _HowItWorks extends StatelessWidget {
  static const _steps = [
    _Step(1, Icons.account_balance_wallet_rounded, 'CONNECT\nYOUR\nPORTFOLIO'),
    _Step(2, Icons.lock_open_rounded,              'UNLOCK\nYOUR\nLIMIT'),
    _Step(3, Icons.shopping_bag_rounded,           'SHOP &\nPAY\nLATER'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            _StepWidget(step: _steps[i]),
            if (i < _steps.length - 1)
              Expanded(
                child: Container(
                  height: 1.5,
                  margin: const EdgeInsets.only(bottom: 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.4),
                        AppColors.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepWidget extends StatelessWidget {
  final _Step step;
  const _StepWidget({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, color: AppColors.primary, size: 28),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
            letterSpacing: 0.3,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _Step {
  final int number;
  final IconData icon;
  final String label;
  const _Step(this.number, this.icon, this.label);
}

// ─── 6. Refer & Earn Banner ───────────────────────────────────────────────────

class _ReferEarnBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B1FA8), Color(0xFF6C3CE1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // INVITE badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.person_add_rounded,
                          color: Colors.white, size: 12),
                      SizedBox(width: 5),
                      Text(
                        'INVITE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: 'Get '),
                      TextSpan(
                        text: 'upto ₹1000',
                        style: TextStyle(
                          color: Color(0xFFFBBF24),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(text: ' for every\nfriend.'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Plus they'll also get rewards.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right — REFER AND EARN text
          Column(
            children: [
              for (final word in ['REFER', 'AND', 'EARN'])
                Text(
                  word,
                  style: TextStyle(
                    color: word == 'EARN'
                        ? const Color(0xFFFBBF24)
                        : Colors.white,
                    fontSize: word == 'AND' ? 14 : 22,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 7. FAQ Section ───────────────────────────────────────────────────────────

class _FaqSection extends StatefulWidget {
  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  int? _openIndex;

  static const _faqs = [
    _Faq('What is 1Fi?',
        '1Fi is a fintech platform that lets you shop on no-cost EMI using your mutual fund portfolio as collateral, without a credit score check.'),
    _Faq('Is 1Fi safe and legit?',
        'Yes. 1Fi is a SEBI-registered platform backed by your existing mutual fund investments. No funds are sold or transferred.'),
    _Faq('Who is the RBI approved lending partner?',
        '1Fi works with RBI-registered NBFCs to provide the credit facility secured against your mutual fund portfolio.'),
    _Faq('What documents are needed to take a loan?',
        'You need your PAN card, Aadhaar, and your mutual fund portfolio linked to your account. The KYC process is fully digital.'),
    _Faq('Are there any hidden fees?',
        'No. 1Fi charges zero processing fees, zero foreclosure charges, and zero hidden fees. You only pay the EMI amount.'),
    _Faq('What if markets fall?',
        'Your pledged mutual fund units act as collateral. If markets fall significantly, 1Fi may request additional collateral or partial repayment.'),
    _Faq('Are there any charges if I pay early to release my pledged mutual fund units?',
        'No foreclosure charges apply. You can repay anytime and your mutual fund units will be released immediately.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: _faqs.asMap().entries.map((e) {
              final i = e.key;
              final faq = e.value;
              final isOpen = _openIndex == i;
              final isLast = i == _faqs.length - 1;

              return Column(
                children: [
                  InkWell(
                    onTap: () =>
                        setState(() => _openIndex = isOpen ? null : i),
                    borderRadius: BorderRadius.vertical(
                      top: i == 0 ? const Radius.circular(14) : Radius.zero,
                      bottom: isLast
                          ? const Radius.circular(14)
                          : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq.question,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isOpen
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isOpen
                                    ? AppColors.primary
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: AppConstants.animFast,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: isOpen
                                  ? AppColors.primary
                                  : AppColors.textHint,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Text(
                        faq.answer,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.55,
                        ),
                      ),
                    ),
                    crossFadeState: isOpen
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: AppConstants.animFast,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: AppColors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        // View all FAQs button
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View all FAQs',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.primary, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Faq {
  final String question, answer;
  const _Faq(this.question, this.answer);
}
