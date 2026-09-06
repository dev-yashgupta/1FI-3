import 'package:flutter/foundation.dart';

/// App-wide constants — spacing, radius, durations, API config.
abstract class AppConstants {
  // ── Spacing ───────────────────────────────────────
  static const double spaceXS  = 4.0;
  static const double spaceSM  = 8.0;
  static const double spaceMD  = 16.0;
  static const double spaceLG  = 24.0;
  static const double spaceXL  = 32.0;
  static const double spaceXXL = 48.0;

  // ── Border radius ─────────────────────────────────
  static const double radiusSM   = 8.0;
  static const double radiusMD   = 12.0;
  static const double radiusLG   = 16.0;
  static const double radiusXL   = 24.0;
  static const double radiusPill = 100.0;

  // ── Animation durations ───────────────────────────
  static const Duration animFast   = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow   = Duration(milliseconds: 400);

  // ── API configuration ─────────────────────────────
  ///
  /// Override at build time:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.x:3000
  ///
  /// Platform defaults when no override is given:
  ///   Android emulator  →  http://10.0.2.2:3000   (maps to host localhost)
  ///   iOS simulator     →  http://localhost:3000
  ///   Web (Chrome)      →  http://localhost:3000   (same origin)
  ///   Physical device   →  your machine's LAN IP, e.g. http://192.168.1.100:3000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb
        ? 'http://localhost:3000'   // web runs on same machine
        : 'http://10.0.2.2:3000',  // Android emulator default
  );

  static const Duration apiTimeout = Duration(seconds: 15);

  // ── Data source ───────────────────────────────────
  /// true  = use mock JSON asset (no backend needed)
  /// false = use live Express + Supabase backend
  ///
  /// Set via: --dart-define=USE_MOCK=false
  static const bool useMock =
      bool.fromEnvironment('USE_MOCK', defaultValue: kDebugMode);

  // ── App info ──────────────────────────────────────
  static const String appName          = '1Fi';
  static const String marketplaceTitle = '1Fi Marketplace';
}
