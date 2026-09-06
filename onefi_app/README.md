# 1Fi App — Flutter

The Flutter frontend for the **1Fi Marketplace** assignment.
Runs on **Android**, **iOS**, and **Web (Chrome/Edge)**.

---

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run on Chrome (mock data — no backend needed)
flutter run -d chrome

# Run on Android emulator
flutter run -d emulator-5554

# Run with live backend
flutter run -d chrome --dart-define=USE_MOCK=false
```

---

## Project Structure

```
lib/
├── main.dart                   # Entry point, responsive web container, fullscreen
├── core/
│   ├── constants/              # AppConstants (API URL, spacing, radius)
│   │   ├── app_constants.dart
│   │   └── app_routes.dart     # GoRouter navigation config
│   ├── theme/                  # 1Fi brand design tokens
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── currency_formatter.dart   # Indian ₹ format
│   │   ├── fullscreen_web.dart       # Browser Fullscreen API (web)
│   │   └── fullscreen_stub.dart      # No-op stub (mobile)
│   └── widgets/                # Shared reusable widgets
│       ├── app_button.dart
│       ├── app_network_image.dart
│       ├── error_view.dart
│       └── empty_view.dart
├── data/
│   ├── models/                 # Pure Dart data classes
│   │   ├── product.dart
│   │   ├── product_variant.dart
│   │   └── emi_plan.dart
│   ├── datasources/            # Data access layer
│   │   ├── product_datasource.dart         # Abstract interface
│   │   ├── mock_product_datasource.dart    # Loads from assets/mock/
│   │   ├── remote_product_datasource.dart  # Calls Express API via Dio
│   │   └── api_client.dart                 # Singleton Dio + error handling
│   └── repositories/
│       └── product_repository.dart   # Selects mock or remote, auto-fallback
└── features/
    ├── shell/          # AppShell — bottom NavigationBar wrapper
    ├── home/           # Home screen
    ├── shop/           # Shop screen (3 tabs)
    ├── emi_dues/       # EMI Dues screen
    ├── limit/          # Limit screen
    ├── profile/        # Profile screen
    └── marketplace/
        ├── providers/  # Riverpod StateNotifiers
        ├── screens/    # MarketplaceScreen · ProductDetailScreen · ConfirmationSheet
        └── widgets/    # ProductCard · ProductListTile · ProductCardShimmer
                        # VariantSelector · EmiPlanCard
```

---

## Data Source Switching

The app uses `--dart-define` flags to switch between mock and live data:

| Flag | Effect |
|------|--------|
| *(none, debug)* | Mock data from `assets/mock/products.json` |
| `USE_MOCK=false` | Live data from Express backend |
| `USE_MOCK=true` | Force mock even in release |
| `API_BASE_URL=http://...` | Override the backend URL |

**Examples:**

```bash
# Mock data (default in debug)
flutter run -d chrome

# Live backend on same machine (web)
flutter run -d chrome --dart-define=USE_MOCK=false

# Live backend on Android emulator (10.0.2.2 = host localhost)
flutter run -d emulator-5554 --dart-define=USE_MOCK=false

# Physical device — use your machine's LAN IP
flutter run --dart-define=USE_MOCK=false \
            --dart-define=API_BASE_URL=http://192.168.1.100:3000
```

**Auto-fallback:** If `USE_MOCK=false` but the backend is unreachable, the repository silently serves mock data so the app never crashes.

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod ^2.6.1` | State management (`StateNotifier`) |
| `go_router ^14.8.1` | Declarative routing |
| `dio ^5.8.0` | HTTP client with error handling |
| `cached_network_image ^3.4.1` | Image loading + disk cache |
| `shimmer ^3.0.0` | Skeleton loading animations |
| `web ^1.1.1` | Browser Fullscreen API (web only) |

---

## Assets

```
assets/
├── images/          # Static image assets
└── mock/
    └── products.json   # 5 demo products with variants and EMI plans
```

---

## Flutter Version

```
Flutter  3.44.0
Dart     3.12.0
```

See the [root README](../README.md) for the full project documentation including backend setup, architecture, and the complete feature list.
