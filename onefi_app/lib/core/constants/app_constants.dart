/// App-wide constants — spacing, radius, durations, API config.
abstract class AppConstants {
  // ── Spacing ───────────────────────────────────────
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // ── Border radius ─────────────────────────────────
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusPill = 100.0;

  // ── Elevation ─────────────────────────────────────
  static const double elevationCard = 0.0;
  static const double elevationModal = 8.0;

  // ── Animation durations ───────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);

  // ── API ───────────────────────────────────────────
  /// Change this to your deployed backend URL.
  /// For local dev use http://10.0.2.2:3000 (Android emulator)
  /// or http://localhost:3000 (iOS simulator / web)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration apiTimeout = Duration(seconds: 15);

  // ── Pagination ────────────────────────────────────
  static const int pageSize = 20;

  // ── App info ──────────────────────────────────────
  static const String appName = '1Fi';
  static const String marketplaceTitle = '1Fi Marketplace';
}
