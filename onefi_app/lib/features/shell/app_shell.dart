import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

/// Persistent bottom navigation — matches 1Fi floating white pill nav bar.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    _Tab('Home',     Icons.home_outlined,         Icons.home_rounded,          '/home'),
    _Tab('Shop',     Icons.storefront_outlined,    Icons.storefront_rounded,    '/shop'),
    _Tab('EMI Dues', Icons.receipt_long_outlined,  Icons.receipt_long_rounded,  '/emi-dues'),
    _Tab('Limit',    Icons.bar_chart_outlined,     Icons.bar_chart_rounded,     '/limit'),
    _Tab('Profile',  Icons.person_outline_rounded, Icons.person_rounded,        '/profile'),
  ];

  int _idx(BuildContext ctx) {
    final loc = GoRouterState.of(ctx).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _idx(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(12, 0, 12, bottomPad > 0 ? bottomPad : 12),
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x18000000), blurRadius: 24, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: idx,
            onDestinationSelected: (i) => context.go(_tabs[i].path),
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppColors.primary.withValues(alpha: 0.10),
            height: 64,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: _tabs.map((t) => NavigationDestination(
              icon:          Icon(t.icon,       color: AppColors.navUnselected, size: 22),
              selectedIcon:  Icon(t.activeIcon, color: AppColors.navSelected,   size: 22),
              label: t.label,
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final String label, path;
  final IconData icon, activeIcon;
  const _Tab(this.label, this.icon, this.activeIcon, this.path);
}
