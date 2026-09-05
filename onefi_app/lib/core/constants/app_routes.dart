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
      builder: (context, routerState, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, routerState) => const HomeScreen()),
        GoRoute(path: '/shop', builder: (context, routerState) => const ShopScreen()),
        GoRoute(path: '/emi-dues', builder: (context, routerState) => const EmiDuesScreen()),
        GoRoute(path: '/limit', builder: (context, routerState) => const LimitScreen()),
        GoRoute(path: '/profile', builder: (context, routerState) => const ProfileScreen()),
      ],
    ),

    // ── Marketplace (full screen, no bottom nav) ─────
    GoRoute(
      path: '/marketplace',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, routerState) => const MarketplaceScreen(),
    ),
    GoRoute(
      path: '/marketplace/:slug',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ProductDetailScreen(
        slug: state.pathParameters['slug']!,
      ),
    ),
  ],
);
