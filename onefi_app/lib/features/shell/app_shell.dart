import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

/// Persistent bottom nav shell — matches 1Fi floating white pill nav bar.
/// Uses StatefulWidget + RouteObserver pattern so the selected index always
/// reflects the active route correctly with GoRouter ShellRoute.
class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _paths = [
    '/home',
    '/shop',
    '/emi-dues',
    '/limit',
    '/profile',
  ];

  static const _labels = ['Home', 'Shop', 'EMI Dues', 'Limit', 'Profile'];

  static const _icons = [
    Icons.home_outlined,
    Icons.storefront_outlined,
    Icons.receipt_long_outlined,
    Icons.bar_chart_outlined,
    Icons.person_outline_rounded,
  ];

  static const _activeIcons = [
    Icons.home_rounded,
    Icons.storefront_rounded,
    Icons.receipt_long_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndex();
  }

  void _updateIndex() {
    // Read current location from the nearest GoRouter
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) {
        if (_selectedIndex != i) {
          setState(() => _selectedIndex = i);
        }
        return;
      }
    }
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
            12, 0, 12, bottomPad > 0 ? bottomPad : 12),
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppColors.primary.withValues(alpha: 0.10),
            height: 64,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: List.generate(
              _paths.length,
              (i) => NavigationDestination(
                icon: Icon(_icons[i],
                    color: AppColors.navUnselected, size: 22),
                selectedIcon: Icon(_activeIcons[i],
                    color: AppColors.navSelected, size: 22),
                label: _labels[i],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
