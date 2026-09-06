import 'package:flutter/material.dart';

/// 1Fi brand color palette — pixel-matched from live app screenshots.
abstract class AppColors {
  // ── Primary purple ──────────────────────────────────
  static const Color primary      = Color(0xFF6C3CE1);
  static const Color primaryDark  = Color(0xFF3B1FA8);
  static const Color primaryLight = Color(0xFF8B5CF6);

  // ── Accent yellow ───────────────────────────────────
  static const Color accent      = Color(0xFFFBBF24);
  static const Color accentLight = Color(0xFFFCD34D);

  // ── Background ──────────────────────────────────────
  static const Color background     = Color(0xFFF2F2F7);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EDF8);

  // ── Text ────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFFB0B0C0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── EMI / teal badge ─────────────────────────────────
  static const Color emiBadge   = Color(0xFF10B981); // kept for all widgets
  static const Color emiBadgeText = Color(0xFFFFFFFF);
  static const Color emiGreen   = Color(0xFF10B981);
  static const Color emiGreenBg = Color(0xFFD1FAE5);

  // ── Status ──────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error   = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // ── Divider / border ────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border  = Color(0xFFD1D5DB);

  // ── Card shadow (kept for app_theme.dart ColorScheme) ──
  static const Color cardShadow = Color(0x1A6C3CE1);

  // ── Shimmer ─────────────────────────────────────────
  static const Color shimmerBase      = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF9FAFB);

  // ── Bottom nav ──────────────────────────────────────
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected   = Color(0xFF6C3CE1);
  static const Color navUnselected = Color(0xFF9CA3AF);

  // ── Tab bar ─────────────────────────────────────────
  static const Color tabSelected   = Color(0xFF6C3CE1);
  static const Color tabUnselected = Color(0xFF6B7280);
  static const Color tabBarBg      = Color(0xFFFFFFFF);

  // ── Shadow ──────────────────────────────────────────
  static const Color shadow = Color(0x1A000000);
}
