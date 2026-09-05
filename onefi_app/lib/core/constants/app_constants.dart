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

  // ── Animation durations ───────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);

  // ── API base URL ──────────────────────────────────
  /// Override at build time:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.x:3000
  ///
  /// Defaults:
  ///   Android emulator → 10.0.2.2:3000  (maps to host machine localhost)
  ///   iOS simulator    → 127.0.0.1:3000
  ///   Physical device  → your machine's LAN IP, e.g. 192.168.1.100:3000
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
