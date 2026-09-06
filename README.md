# 1Fi Marketplace — SDE Intern Assignment

A Flutter mobile application implementing the **1Fi Marketplace** feature within the existing 1Fi Shop experience, backed by a Node.js + Express API connected to a Supabase (PostgreSQL) database.

---

## Table of Contents

1. [Feature Overview](#feature-overview)
2. [User Flow](#user-flow)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Data Architecture](#data-architecture)
6. [State Management](#state-management)
7. [API / Mock Data](#api--mock-data)
8. [How to Run](#how-to-run)
9. [Backend Setup (Supabase)](#backend-setup-supabase)
10. [How to Test](#how-to-test)
11. [Assumptions](#assumptions)
12. [Known Limitations](#known-limitations)

---

## Feature Overview

The 1Fi Marketplace is a new section added to the existing **Shop** page of the 1Fi app. It allows users to browse products and purchase them on flexible no-cost EMI plans backed by their mutual fund portfolio.

### Shop Page — Three Tabs

| Tab | Status |
|-----|--------|
| Top Brands | Placeholder (per spec) |
| Nearby Stores | Placeholder (per spec) |
| **1Fi Marketplace** | **Fully implemented** |

### Marketplace Features

- Product listing grid with search and category filter
- Shimmer skeleton loading state
- Error state with retry
- Empty state handling
- Product detail screen with image, pricing, rating
- Variant selector (storage + color with live swatches)
- EMI plan selection (selectable cards, radio-style)
- Proceed CTA — disabled until variant + EMI plan selected
- Confirmation bottom sheet with full plan summary
- Pull-to-refresh

---

## User Flow

```
App Launch
    └── Home (bottom nav)
    └── Shop (bottom nav)
           ├── Top Brands tab        [blank]
           ├── Nearby Stores tab     [blank]
           └── 1Fi Marketplace tab
                   └── [Explore Now] → Marketplace Screen
                           └── Product Card → Product Detail Screen
                                   ├── Choose Variant (storage + color)
                                   ├── Select EMI Plan
                                   └── [Proceed with Selected Plan]
                                           └── Confirmation Bottom Sheet
                                                   └── [Continue] → Success snackbar
```

---

## Architecture

```
Flutter App (onefi_app/)
│
├── core/
│   ├── theme/          AppColors, AppTextStyles, AppTheme
│   ├── constants/      AppConstants, AppRoutes (GoRouter)
│   ├── utils/          CurrencyFormatter (₹ Indian format)
│   └── widgets/        AppButton, AppNetworkImage, ErrorView, EmptyView
│
├── data/
│   ├── models/         Product, ProductVariant, EmiPlan
│   ├── datasources/    MockProductDataSource, RemoteProductDataSource, ApiClient
│   └── repositories/   ProductRepository
│
└── features/
    ├── shell/          AppShell (bottom nav wrapper)
    ├── home/           HomeScreen
    ├── shop/           ShopScreen (3 tabs)
    ├── emi_dues/       EmiDuesScreen
    ├── limit/          LimitScreen
    ├── profile/        ProfileScreen
    └── marketplace/
        ├── providers/  MarketplaceNotifier, ProductDetailNotifier (Riverpod)
        ├── screens/    MarketplaceScreen, ProductDetailScreen, ConfirmationSheet
        └── widgets/    ProductCard, ProductCardShimmer, VariantSelector, EmiPlanCard

Backend (backend/)
│
├── src/
│   ├── server.js           Express app entry
│   ├── routes/             productRoutes.js
│   ├── controllers/        productController.js
│   ├── services/           productService.js (Prisma queries)
│   ├── config/             db.js (Prisma singleton)
│   └── middleware/         errorHandler.js
│
└── prisma/
    ├── schema.prisma       Product, Variant, EmiPlan models
    └── seed.js             Demo seed data
```

---

## Project Structure

```
Assignment-3/
├── auto_commit.bat         # One-shot auto commit (Windows)
├── auto_commit.ps1         # Watch-mode auto commit (PowerShell)
├── .gitignore
├── README.md
│
├── backend/                # Node.js + Express + Prisma
│   ├── .env.example
│   ├── package.json
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── seed.js
│   └── src/
│
└── onefi_app/              # Flutter application
    ├── pubspec.yaml
    ├── assets/
    │   ├── images/
    │   └── mock/
    │       └── products.json
    └── lib/
        ├── main.dart
        ├── core/
        ├── data/
        └── features/
```

---

## Data Architecture

### Models

```dart
Product {
  id, name, slug, brand, description, category,
  imageUrl, mrp, basePrice, rating, reviewCount,
  badges[], variants[], emiPlans[]
}

ProductVariant {
  id, productId, storage, color, colorSwatch,
  finish, price, mrp, imageUrl, inStock
}

EmiPlan {
  id, productId, monthlyAmount, tenureMonths,
  interestRate, cashback, tag, bankName
}
```

### Data Flow

```
UI Widget
    └── ref.watch(marketplaceProvider)
            └── MarketplaceNotifier
                    └── ProductRepository
                            └── MockProductDataSource  ← assets/mock/products.json
                            └── RemoteProductDataSource ← GET /api/products (when live)
                                    └── ApiClient (Dio)
                                            └── Express API → Prisma → Supabase
```

---

## State Management

**Riverpod** (`flutter_riverpod: ^2.6.1`)

### MarketplaceState (product listing)

| Status | When |
|--------|------|
| `initial` | Not yet loaded |
| `loading` | Fetching products |
| `success` | Products loaded |
| `error` | Network / parse failure |
| `empty` | No products returned |

### ProductDetailState (per-product)

Scoped per slug using `StateNotifierProvider.family`.

Tracks: `product`, `selectedVariant`, `selectedEmiPlan`, `status`, `errorMessage`

`canProceed` = `selectedVariant != null && selectedEmiPlan != null`

---

## API / Mock Data

### Currently Active: Mock Data

Products are loaded from `assets/mock/products.json` via `MockProductDataSource`.

This simulates an 800ms network delay so loading states are visible.

**5 demo products:**
1. iPhone 17 Pro (4 variants, 5 EMI plans)
2. Samsung Galaxy S25 Ultra (4 variants, 5 EMI plans)
3. Google Pixel 9 Pro (3 variants, 5 EMI plans)
4. Sony WH-1000XM6 headphones (2 variants, 3 EMI plans)
5. MacBook Air M4 (4 variants, 5 EMI plans)

> **Note:** All product data, pricing, and EMI plans are demonstration seed data only.
> They do not represent actual 1Fi commercial offerings.

### Switching to Live API

1. Set `DATABASE_URL` and `DIRECT_URL` in `backend/.env` (see `.env.example`)
2. Run `npm run db:push && npm run db:seed` in `backend/`
3. In `onefi_app/lib/data/repositories/product_repository.dart`, replace `MockProductDataSource` with `RemoteProductDataSource`
4. Set the `API_BASE_URL` build arg: `flutter run --dart-define=API_BASE_URL=http://YOUR_IP:3000`

### Backend API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/products` | All products (listing view) |
| GET | `/api/products/:slug` | Single product with variants + EMI plans |
| GET | `/api/products/:slug/variants` | Variants for a product |
| GET | `/api/products/:slug/emi-plans` | EMI plans for a product |

---

## How to Run

### Prerequisites

- Flutter 3.44+ / Dart 3.12+
- Android emulator or physical device

### Flutter App

```bash
cd onefi_app
flutter pub get
flutter run
```

For a specific device:
```bash
flutter run -d <device-id>
```

With live backend:
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

---

## Backend Setup (Supabase)

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) → New project
2. Note your **project ref**, **database password**

### 2. Get Connection Strings

In Supabase dashboard → Settings → Database → Connection string:
- **Transaction pooler** (port 6543) → `DATABASE_URL`
- **Direct connection** (port 5432) → `DIRECT_URL`

### 3. Configure Backend

```bash
cd backend
cp .env.example .env
# Fill in DATABASE_URL and DIRECT_URL with your Supabase values
```

### 4. Install & Migrate

```bash
npm install
npm run db:generate   # generate Prisma client
npm run db:push       # push schema to Supabase
npm run db:seed       # seed demo products
```

### 5. Start the Server

```bash
npm run dev           # development with nodemon
# or
npm start             # production
```

API available at `http://localhost:3000`

---

## How to Test

### Manual Test Checklist

**Shop:**
- [ ] App opens on Home screen with bottom nav
- [ ] Tap Shop → Shop page opens with 3 tabs
- [ ] Top Brands tab → blank placeholder
- [ ] Nearby Stores tab → blank placeholder
- [ ] 1Fi Marketplace tab → entry card visible
- [ ] Tap "Explore Now" → Marketplace screen opens

**Marketplace:**
- [ ] Shimmer loading shows for ~800ms
- [ ] 5 product cards render with images, names, prices
- [ ] Search bar filters products by name/brand
- [ ] Category chips filter by Smartphones/Audio/Laptops
- [ ] Pull-to-refresh reloads products

**Product Detail:**
- [ ] Tap any product card → detail screen opens
- [ ] Product image renders
- [ ] Name, brand, price, MRP, discount % shown
- [ ] Star rating displayed
- [ ] "About" section shows description

**Variants:**
- [ ] Storage chips appear (e.g., 256 GB / 512 GB / 1 TB)
- [ ] Tapping a storage chip selects it and highlights
- [ ] Color swatches appear for selected storage
- [ ] Tapping a color updates selected state
- [ ] Product image animates to variant image
- [ ] Out-of-stock variants shown as disabled

**EMI Plans:**
- [ ] All EMI plans listed with monthly amount
- [ ] Tenure, interest rate, cashback shown per plan
- [ ] "Popular" / "Best Value" tags shown
- [ ] Tapping a plan selects it (radio-style with checkmark)
- [ ] Only one plan selected at a time

**Proceed CTA:**
- [ ] Button disabled before any selection
- [ ] Button enabled after variant + EMI plan selected
- [ ] Hint text "Select a variant and EMI plan to proceed" visible
- [ ] Tapping button → confirmation bottom sheet appears

**Confirmation:**
- [ ] Product name shown
- [ ] Variant (storage + color) shown
- [ ] Monthly EMI amount highlighted
- [ ] Tenure, interest rate, cashback, bank shown
- [ ] Tap "Continue" → sheet dismisses + success snackbar
- [ ] Tap "Change Plan" → sheet dismisses

**Error / Loading / Empty:**
- [ ] Loading shimmer shows on first load
- [ ] Error view with "Try Again" button
- [ ] Retry actually reloads

**Navigation:**
- [ ] Back button works on all screens
- [ ] Bottom nav persists on main tabs
- [ ] Bottom nav hidden on Marketplace + Product Detail

---

