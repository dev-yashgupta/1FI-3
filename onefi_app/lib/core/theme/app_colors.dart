import 'package:flutter/material.dart';

/// 1Fi brand color palette — derived from the live app screenshots.
abstract class AppColors {
  // ── Primary purple ──────────────────────────────────
  static const Color primary = Color(0xFF5B2ECC);
  static const Color primaryLight = Color(0xFF7B52E0);
  static const Color primaryDark = Color(0xFF3D1A99);

  // ── Accent / highlight ──────────────────────────────
  static const Color accent = Color(0xFFFFC107); // gold/yellow
  static const Color accentLight = Color(0xFFFFD54F);

  // ── Background ──────────────────────────────────────
  static const Color background = Color(0xFFF4F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EDF8);

  // ── Text ────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Status ──────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);

  // ── Divider / border ────────────────────────────────
  static const Color divider = Color(0xFFE8E8F0);
  static const Color border = Color(0xFFDDDDEE);

  // ── Card / shadow ───────────────────────────────────
  static const Color cardShadow = Color(0x1A5B2ECC);
  static const Color shimmerBase = Color(0xFFEEEEEE);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── EMI badge ───────────────────────────────────────
  static const Color emiBadge = Color(0xFF1ABC9C);
  static const Color emiBadgeText = Color(0xFFFFFFFF);

  // ── Bottom nav ──────────────────────────────────────
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected = Color(0xFF5B2ECC);
  static const Color navUnselected = Color(0xFF9E9EB0);
}
