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

final _rootNavigatorKey   = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey  = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  debugLogDiagnostics: false,
  routes: [
    // ── Shell — persistent bottom nav ──────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ShopScreen(),
          ),
        ),
        GoRoute(
          path: '/emi-dues',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: EmiDuesScreen(),
          ),
        ),
        GoRoute(
          path: '/limit',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LimitScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // ── Marketplace — full screen, no bottom nav ───
    GoRoute(
      path: '/marketplace',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MarketplaceScreen(),
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
