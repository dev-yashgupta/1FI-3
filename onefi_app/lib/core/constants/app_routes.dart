import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/shell/app_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/shop/screens/shop_screen.dart';
import '../../features/emi_dues/emi_dues_screen.dart';
import '../../features/limit/limit_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/marketplace/screens/marketplace_screen.dart';
import '../../features/marketplace/screens/product_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // ── Shell (bottom nav) ───────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _s) => const HomeScreen()),
        GoRoute(path: '/shop', builder: (_, _s) => const ShopScreen()),
        GoRoute(path: '/emi-dues', builder: (_, _s) => const EmiDuesScreen()),
        GoRoute(path: '/limit', builder: (_, _s) => const LimitScreen()),
        GoRoute(path: '/profile', builder: (_, _s) => const ProfileScreen()),
      ],
    ),

    // ── Marketplace (full screen, no bottom nav) ─────
    GoRoute(
      path: '/marketplace',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _s) => const MarketplaceScreen(),
    ),
    GoRoute(
      path: '/marketplace/:slug',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => ProductDetailScreen(
        slug: state.pathParameters['slug']!,
      ),
    ),
  ],
);
