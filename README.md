# 1Fi Marketplace — SDE Intern Assignment

> Built by **Yash Gupta** as part of the 1Fi SDE Intern take-home assignment.

A full-stack implementation of the **1Fi Marketplace** feature inside the existing 1Fi Shop experience — built with Flutter (mobile + web), Node.js + Express (API), Prisma ORM, and Supabase (PostgreSQL).

---

## Table of Contents

1. [Assignment Objective](#1-assignment-objective)
2. [Live Demo](#2-live-demo)
3. [Tech Stack](#3-tech-stack)
4. [Features Implemented](#4-features-implemented)
5. [Screenshots](#5-screenshots)
6. [Architecture](#6-architecture)
7. [Project Structure](#7-project-structure)
8. [Data Models](#8-data-models)
9. [State Management](#9-state-management)
10. [API Reference](#10-api-reference)
11. [Quick Start](#11-quick-start)
12. [Backend Setup (Supabase)](#12-backend-setup-supabase)
13. [Running with Live Backend](#13-running-with-live-backend)
14. [Test Checklist](#14-test-checklist)
15. [Evaluation Criteria Coverage](#15-evaluation-criteria-coverage)
16. [Assumptions & Decisions](#16-assumptions--decisions)
17. [Known Limitations](#17-known-limitations)

---

## 1. Assignment Objective

> Build the **1Fi Marketplace** section within the existing Shop page of the 1Fi app.

The Shop page exposes three tabs:

| Tab | Requirement | Status |
|-----|-------------|--------|
| Top Brands | No implementation required | ✅ Placeholder with search |
| Nearby Stores | No implementation required | ✅ Placeholder with search |
| **1Fi Marketplace** | **Fully designed & implemented** | ✅ Complete |

---

## 2. Live Demo

Run locally in under 2 minutes:

```bash
cd onefi_app
flutter pub get
flutter run -d chrome          # web — no backend needed (uses mock data)
flutter run -d <android-id>    # Android emulator
```

---

## 3. Tech Stack

### Frontend (Mobile + Web)

| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.44.0 | Cross-platform UI framework |
| **Dart** | 3.12.0 | Language |
| **flutter_riverpod** | 2.6.1 | State management |
| **go_router** | 14.8.1 | Declarative navigation |
| **dio** | 5.8.0 | HTTP client |
| **cached_network_image** | 3.4.1 | Image loading + caching |
| **shimmer** | 3.0.0 | Skeleton loading UI |
| **web** | 1.1.1 | Browser Fullscreen API (web only) |

### Backend (API Server)

| Technology | Version | Purpose |
|------------|---------|---------|
| **Node.js** | 22.x | Runtime |
| **Express** | 5.2.1 | HTTP framework |
| **Prisma** | 7.10.0 | ORM + schema management |
| **Supabase** | — | PostgreSQL cloud database |
| **dotenv** | 17.x | Environment configuration |
| **nodemon** | 3.x | Dev auto-restart |

---

## 4. Features Implemented

### App Shell

- Bottom navigation bar: **Home · Shop · EMI Dues · Limit · Profile**
- Floating pill-style nav (matches 1Fi design)
- All 5 screens implemented
- Navigation fixes: `StatefulWidget` shell + `NoTransitionPage` for instant tab switching

### Home Screen

- Purple gradient hero banner with "Shop on no-cost EMI" CTA
- Offer carousel with 6 categories and animated dot indicators
- "Shop Using 1Fi at Top Brands" horizontal brand logo row
- Feature chips grid: Keep growing · 0% interest · Quickest approvals · Zero charges
- **How 1Fi Works** — 3-step flow with numbered purple circle icons
- **Refer & Earn** banner with animated purple gradient
- **FAQ accordion** — 7 expandable questions with animated arrows

### Shop Screen

- Purple gradient hero banner matching 1Fi design
- Pill-style 3-tab switcher (Top Brands / Nearby Stores / 1Fi Marketplace)
- Top Brands tab: searchable brand list with 30+ brands and icons
- Nearby Stores tab: search bar + empty state
- 1Fi Marketplace tab: tapping navigates directly to Marketplace screen

### 1Fi Marketplace — Product Listing

- Responsive product grid (2 cols mobile → 3 cols tablet → 4 cols web)
- **Search** with real-time filter + clear button
- **Category chips** with icons (All / Smartphones / Audio / Laptops)
- **Sort** bottom sheet: Relevance · Price Low→High · Price High→Low · Top Rated · Best Discount
- **Grid / List toggle** — switches between card grid and horizontal list tiles
- Result count bar with active sort chip
- Shimmer skeleton loading (exact height match — no overflow)
- Error state with retry button
- Empty state for no results
- Pull-to-refresh

### ProductCard

- Scale press animation (96% on tap-down)
- Wishlist heart button (toggle, local state)
- Star rating + review count
- Price + MRP strikethrough + discount badge
- EMI teaser chip
- "View Details" CTA

### Product Detail Screen

- Animated image switcher (fade transition between variants)
- **Variant thumbnail strip** — horizontal scrollable mini images
- Brand pill + category badge
- Price, MRP, discount %, **"You save ₹X,XXX"** savings callout
- Star rating row
- **Delivery highlights**: Free delivery · Genuine product · 7-day return
- **Variant selector** — storage chips (with price diff) + color swatches (with OOS badge)
- **Description** card
- **EMI Plans** — full plan cards with total payable + cashback footer
- Proceed bar — shows selected plan summary when EMI chosen
- Share button in AppBar

### EMI Plan Selection

- Animated radio-style selection with checkmark
- Monthly amount, tenure, interest rate info chips
- **Total payable** calculation (monthly × tenure)
- Cashback in gold with gift icon
- "Popular" / "Best Value" tag badges
- Clearing variant resets EMI plan automatically

### Confirmation Bottom Sheet

- Elastic spring scale-in animation on check icon
- Full order summary with icons per row
- Savings callout in green
- Continue → dismisses sheet + green success snackbar
- Change Plan → goes back

### Additional UX

- **Web fullscreen button** (top-right): enters browser fullscreen, tap again to exit
- **Dot grid background** on web outside the phone frame
- **Hover effect** on fullscreen button
- Auto-fallback: if backend unreachable → silently falls back to mock data

---

## 5. Screenshots

> Run the app to see the full experience. Key screens:

| Screen | Route |
|--------|-------|
| Home | `/home` |
| Shop (3 tabs) | `/shop` |
| Marketplace listing | `/marketplace` |
| Product detail | `/marketplace/:slug` |
| EMI + Confirmation | (bottom sheet) |

---

## 6. Architecture

```
Flutter App
├── core/
│   ├── theme/          AppColors · AppTextStyles · AppTheme
│   ├── constants/      AppConstants · AppRoutes (GoRouter)
│   ├── utils/          CurrencyFormatter · FullscreenHelper
│   └── widgets/        AppButton · AppNetworkImage · ErrorView · EmptyView
│
├── data/
│   ├── models/         Product · ProductVariant · EmiPlan
│   ├── datasources/    ProductDataSource (interface)
│   │                   MockProductDataSource (JSON asset)
│   │                   RemoteProductDataSource (Dio → Express)
│   │                   ApiClient (singleton Dio)
│   └── repositories/   ProductRepository (with auto-fallback)
│
└── features/
    ├── shell/          AppShell (StatefulWidget, NavigationBar)
    ├── home/           HomeScreen
    ├── shop/           ShopScreen (TabController, 3 inline tabs)
    ├── emi_dues/       EmiDuesScreen
    ├── limit/          LimitScreen
    ├── profile/        ProfileScreen
    └── marketplace/
        ├── providers/  marketplaceProvider · productDetailProvider (Riverpod)
        ├── screens/    MarketplaceScreen · ProductDetailScreen · ConfirmationSheet
        └── widgets/    ProductCard · ProductListTile · ProductCardShimmer
                        VariantSelector · EmiPlanCard

Backend
├── src/
│   ├── server.js           Express entry point
│   ├── config/db.js        Prisma singleton (Supabase)
│   ├── routes/             productRoutes.js
│   ├── controllers/        productController.js
│   ├── services/           productService.js (mappers + Prisma queries)
│   └── middleware/         errorHandler.js
└── prisma/
    ├── schema.prisma       Product · Variant · EmiPlan
    ├── seed.js             5 demo products
    └── prisma7.config.ts   Datasource URL config (Prisma 7)
```

### Data Flow

```
UI (ConsumerWidget)
    │ ref.watch(marketplaceProvider)
    ▼
MarketplaceNotifier  (Riverpod StateNotifier)
    │ repository.getProducts()
    ▼
ProductRepository
    ├── [USE_MOCK=true]  → MockProductDataSource → assets/mock/products.json
    └── [USE_MOCK=false] → RemoteProductDataSource
                              │ Dio GET /api/products
                              ▼
                          Express API (Node.js)
                              │ productService.js
                              ▼
                          Prisma ORM
                              │
                              ▼
                          Supabase PostgreSQL
```

---

## 7. Project Structure

```
Assignment-3/
├── README.md
├── .gitignore
├── auto_commit.bat            # One-shot auto-commit (Windows)
├── auto_commit.ps1            # Watch-mode auto-commit (PowerShell, 5-min interval)
│
├── backend/                   # Node.js + Express + Prisma
│   ├── .env.example           # Copy to .env and fill Supabase values
│   ├── package.json
│   ├── prisma7.config.ts      # Prisma 7 datasource config
│   ├── setup_env.ps1          # Interactive setup wizard
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── seed.js
│   └── src/
│       ├── server.js
│       ├── config/db.js
│       ├── routes/productRoutes.js
│       ├── controllers/productController.js
│       ├── services/productService.js
│       └── middleware/errorHandler.js
│
└── onefi_app/                 # Flutter application
    ├── pubspec.yaml
    ├── assets/
    │   ├── images/
    │   └── mock/
    │       └── products.json  # 5 demo products (used when USE_MOCK=true)
    └── lib/
        ├── main.dart          # App entry, responsive container, fullscreen
        ├── core/
        │   ├── constants/     app_constants.dart · app_routes.dart
        │   ├── theme/         app_colors.dart · app_text_styles.dart · app_theme.dart
        │   ├── utils/         currency_formatter.dart · fullscreen_web.dart · fullscreen_stub.dart
        │   └── widgets/       app_button.dart · app_network_image.dart · error_view.dart · empty_view.dart
        ├── data/
        │   ├── datasources/   api_client.dart · product_datasource.dart
        │   │                  mock_product_datasource.dart · remote_product_datasource.dart
        │   ├── models/        product.dart · product_variant.dart · emi_plan.dart
        │   └── repositories/  product_repository.dart
        └── features/
            ├── shell/         app_shell.dart
            ├── home/          home_screen.dart
            ├── shop/          shop_screen.dart
            ├── emi_dues/      emi_dues_screen.dart
            ├── limit/         limit_screen.dart
            ├── profile/       profile_screen.dart
            └── marketplace/
                ├── providers/ marketplace_provider.dart
                ├── screens/   marketplace_screen.dart · product_detail_screen.dart · confirmation_sheet.dart
                └── widgets/   product_card.dart · product_card_shimmer.dart
                               variant_selector.dart · emi_plan_card.dart
```

---

## 8. Data Models

```dart
// Product — top-level marketplace item
Product {
  String   id, name, slug, brand, description, category
  String   imageUrl
  double   mrp, basePrice
  double   rating
  int      reviewCount
  List<String>          badges
  List<ProductVariant>  variants
  List<EmiPlan>         emiPlans
  // Computed: lowestPrice, discountPercent, shortestEmiPlan, uniqueStorages
}

// ProductVariant — color × storage combination
ProductVariant {
  String  id, productId
  String  storage, color, finish
  Color   colorSwatch   // parsed from colorHex
  double  price, mrp
  String  imageUrl
  bool    inStock
}

// EmiPlan — financing option
EmiPlan {
  String  id, productId
  double  monthlyAmount
  int     tenureMonths
  double  interestRate    // 0.0 = no-cost EMI
  double  cashback
  String  tag             // "Popular", "Best Value"
  String  bankName        // "1Fi Credit"
  // Computed: isNoCost, hasCashback, hasTag
}
```

### Database Schema (Prisma → Supabase)

```
products     id · name · slug · brand · category · mrp · price
             image · rating · review_count · badges · created_at

variants     id · product_id · storage · color · color_hex
             finish · price · mrp · image · in_stock

emi_plans    id · product_id · monthly_amount · tenure_months
             interest_rate · cashback · tag · bank_name
```

---

## 9. State Management

**Riverpod** — `StateNotifier` pattern, no code generation required.

### Providers

```dart
// Repository — injected into all notifiers
productRepositoryProvider  →  Provider<ProductRepository>

// Marketplace listing (all products)
marketplaceProvider        →  StateNotifierProvider<MarketplaceNotifier, MarketplaceState>

// Product detail (scoped per slug)
productDetailProvider      →  StateNotifierProvider.family<ProductDetailNotifier, ProductDetailState, String>
```

### State Machines

**MarketplaceState**

```
initial → loading → success   (products list, category filter, sort)
                  → error     (message + retry)
                  → empty     (no products)
```

**ProductDetailState**

```
initial → loading → success   (product + auto-selected first variant)
                  → error     (not found / network)

canProceed = selectedVariant != null && selectedEmiPlan != null
```

---

## 10. API Reference

Base URL: `http://localhost:3000`

| Method | Endpoint | Response |
|--------|----------|----------|
| `GET` | `/api/health` | `{ status, service, timestamp, database }` |
| `GET` | `/api/products` | `Product[]` with variants + EMI plans |
| `GET` | `/api/products/:slug` | Single `Product` |
| `GET` | `/api/products/:slug/variants` | `Variant[]` |
| `GET` | `/api/products/:slug/emi-plans` | `EmiPlan[]` |

### Response Shape (`GET /api/products`)

```json
[
  {
    "id": "1",
    "name": "iPhone 17 Pro",
    "slug": "iphone-17-pro",
    "brand": "Apple",
    "imageUrl": "https://...",
    "mrp": 134900,
    "basePrice": 127400,
    "rating": 4.8,
    "reviewCount": 2341,
    "badges": ["No-cost EMI", "Free delivery"],
    "variants": [
      {
        "id": "1", "storage": "256 GB", "color": "Natural Titanium",
        "colorHex": "#C5B9A8", "price": 127400, "mrp": 134900,
        "imageUrl": "https://...", "inStock": true
      }
    ],
    "emiPlans": [
      {
        "id": "1", "monthlyAmount": 44967, "tenureMonths": 3,
        "interestRate": 0, "cashback": 7500,
        "tag": "Best Value", "bankName": "1Fi Credit"
      }
    ]
  }
]
```

### Error Shape

```json
{
  "error": {
    "message": "Product not found: invalid-slug"
  }
}
```

---

## 11. Quick Start

### Prerequisites

- Flutter 3.44+ / Dart 3.12+
- Node.js 18+ and npm
- Android emulator, iOS simulator, or Chrome

### Run Flutter (mock data — no backend needed)

```bash
cd onefi_app
flutter pub get
flutter run                    # choose Chrome or Android emulator
```

### Run on Web

```bash
flutter run -d chrome
```

Use the **Fullscreen** button (top-right corner) to expand to full browser width and back.

---

## 12. Backend Setup (Supabase)

### Option A — Automated Setup Wizard (recommended)

```powershell
cd backend
powershell -ExecutionPolicy Bypass -File setup_env.ps1
```

The wizard will:
1. Ask for your Supabase `DATABASE_URL` and `DIRECT_URL`
2. Write `.env`
3. Run `npm install`
4. Run `prisma generate` + `prisma db push` (creates tables)
5. Run `node prisma/seed.js` (inserts 5 demo products)

### Option B — Manual Setup

**1. Create Supabase project**

Go to [supabase.com](https://supabase.com) → New project → any region.

**2. Get connection strings**

Dashboard → **Connect** → **Connection string** → **URI**:
- Transaction pooler (port 6543) → `DATABASE_URL`
- Session pooler / Direct (port 5432) → `DIRECT_URL`

**3. Configure .env**

```bash
cd backend
cp .env.example .env
# Edit .env and paste the two URLs
```

**4. Install, migrate, seed**

```bash
npm install
npm run db:generate   # generate Prisma client from schema
npm run db:push       # create tables in Supabase
npm run db:seed       # insert 5 demo products
```

**5. Start backend**

```bash
npm run dev           # development (nodemon auto-restart)
# or
npm start             # production
```

Verify: [http://localhost:3000/api/health](http://localhost:3000/api/health)

---

## 13. Running with Live Backend

### Web (Chrome — backend on same machine)

```bash
# Terminal 1: start backend
cd backend && npm run dev

# Terminal 2: run Flutter (web auto-uses localhost:3000)
cd onefi_app
flutter run -d chrome --dart-define=USE_MOCK=false
```

### Android Emulator

```bash
flutter run -d emulator-5554 --dart-define=USE_MOCK=false
# 10.0.2.2 automatically routes to host machine localhost
```

### Physical Android Device

```bash
# Find your machine's LAN IP (e.g. ipconfig on Windows)
flutter run --dart-define=USE_MOCK=false \
            --dart-define=API_BASE_URL=http://192.168.1.100:3000
```

### Data Source Selection Logic

```
--dart-define=USE_MOCK=true   → always mock (overrides everything)
--dart-define=USE_MOCK=false  → always remote
(no flag, debug build)        → mock (default)
(no flag, release build)      → remote (default)
```

**Auto-fallback:** If the backend is unreachable, the repository silently falls back to mock data and logs a debug message. The app never crashes or shows a broken screen.

---

## 14. Test Checklist

### App Shell & Navigation

- [x] App launches on Home screen
- [x] Bottom nav: Home · Shop · EMI Dues · Limit · Profile all open correctly
- [x] Profile screen opens without crash (ElevatedButton-in-Row fix applied)
- [x] Back navigation works on all screens

### Shop Screen

- [x] 3-tab pill switcher renders correctly
- [x] Top Brands tab: search bar + brand list (30 brands)
- [x] Nearby Stores tab: empty state
- [x] Tapping **1Fi Marketplace** tab navigates directly to MarketplaceScreen

### Marketplace Listing

- [x] Shimmer skeleton shows during load (~800ms)
- [x] 5 products render in responsive grid
- [x] Search filters by name and brand in real-time
- [x] Category chips filter correctly
- [x] Sort sheet opens with 5 options
- [x] Grid/List toggle switches layout
- [x] Pull-to-refresh reloads products
- [x] Error state with retry button
- [x] Empty state for no results

### Product Detail

- [x] Product image renders
- [x] Animated image switch when changing variants
- [x] Savings callout shown
- [x] Variant thumbnail strip scrolls horizontally
- [x] Storage chips show price diff
- [x] Color swatches with OOS badge
- [x] Delivery highlight chips
- [x] EMI plans render with total payable + cashback
- [x] Selecting variant clears EMI plan

### Proceed Flow

- [x] Button disabled until variant + EMI plan both selected
- [x] Proceed bar shows selected plan summary
- [x] Confirmation sheet opens with spring animation
- [x] Savings row shown in green
- [x] "Continue" → snackbar + sheet closes
- [x] "Change Plan" → sheet closes

### Responsive / Web

- [x] App renders as 420px centered frame on web
- [x] Fullscreen button expands to 100% browser width
- [x] Exit Fullscreen returns to phone frame
- [x] Grid adapts: 2 cols (mobile) → 3 cols (tablet) → 4 cols (wide)
- [x] No overflow on any screen size

---

## 15. Evaluation Criteria Coverage

| Criterion | Implementation |
|-----------|---------------|
| **Product understanding** | Studied live 1Fi app, replicated exact Shop UI (banner, pill tabs, brand list). Used actual 1Fi color palette `#6C3CE1`, typography, spacing, and component patterns. |
| **UI/UX consistency** | All screens match 1Fi visual language. Floating bottom nav, purple gradient hero, pill-style chips, white cards with dividers — all extracted from live app screenshots. |
| **Engineering quality** | Clean architecture: `core/data/features` separation. Abstract `ProductDataSource` interface. Riverpod `StateNotifier` with 5 states. No hardcoded data in UI. No dead code. `flutter analyze` → zero issues. |
| **Functionality** | Complete flow: listing → detail → variants → EMI → proceed → confirmation. All states handled: loading (shimmer), error (retry), empty, success. |
| **Data / API** | Repository pattern with mock/remote switch via `--dart-define`. Auto-fallback to mock if backend unreachable. Backend returns Flutter-friendly JSON (field names matched exactly). |
| **Attention to detail** | Press animations, wishlist toggle, savings callout, price diff on variants, total payable on EMI plans, thumbnail strip, delivery chips, FAQ accordion, Fullscreen web button, dot grid background. |

---

## 16. Assumptions & Decisions

1. **Flutter over React Native** — the assignment mentioned Flutter preference, and the codebase was built green-field in Flutter 3.44.

2. **Mock data by default** — `USE_MOCK=true` in debug so the app works without any backend setup. Switching to live data requires only one `--dart-define` flag change.

3. **Auto-fallback to mock** — `ProductRepository` catches `ApiException` from the remote source and silently serves mock data. This ensures the app is always usable even if the backend isn't running.

4. **No payment gateway** — the assignment explicitly states payment processing is out of scope. The "Continue" button in the confirmation sheet shows a success snackbar as the final step.

5. **Demonstration data only** — all products, pricing, and EMI plans are fabricated seed data. They do not represent actual 1Fi commercial offerings or real financial products.

6. **Supabase over self-hosted PostgreSQL** — free tier, zero infra setup, direct Prisma support, and accessible from any network without exposing a local port.

7. **Prisma 7** — the project was initialized with Prisma 7. The datasource URL moved from `schema.prisma` to `prisma7.config.ts` — this is the correct Prisma 7 pattern.

8. **Web fullscreen** — uses `dart:js_interop` + `package:web` with a no-op stub for mobile. This is the modern Flutter web approach, not the deprecated `dart:html`.


