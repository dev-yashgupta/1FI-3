import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827))),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Avatar card ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: const Icon(Icons.person_rounded,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('1Fi User',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      const Text('user@1fi.in',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Edit',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── KYC / limit card ─────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Your 1Fi Limit',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      Text('₹0',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 6),
                      Text('Complete KYC to unlock your limit',
                          style: TextStyle(
                              color: Colors.white60, fontSize: 11.5)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Start KYC',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Menu items ────────────────────────────────
          _Section(title: 'My Account', items: const [
            _Item(Icons.account_balance_wallet_outlined, 'My Portfolio',     false),
            _Item(Icons.history_rounded,                 'Transaction History', false),
            _Item(Icons.card_giftcard_outlined,          'Referrals & Rewards', false),
          ]),
          const SizedBox(height: 12),
          _Section(title: 'Settings', items: const [
            _Item(Icons.notifications_outlined,  'Notifications', false),
            _Item(Icons.security_outlined,        'Security',      false),
            _Item(Icons.language_rounded,         'Language',      false),
          ]),
          const SizedBox(height: 12),
          _Section(title: 'Support', items: const [
            _Item(Icons.help_outline_rounded,     'Help & Support', false),
            _Item(Icons.info_outline_rounded,     'About 1Fi',      false),
          ]),
          const SizedBox(height: 12),
          // Logout
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded,
                      color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Logout',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFEF4444))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_Item> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 1.0)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(e.value.icon,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(e.value.label,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF111827))),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: Color(0xFFD1D5DB), size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 48,
                        color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final bool destructive;
  const _Item(this.icon, this.label, this.destructive);
}
