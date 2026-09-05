// 1Fi Marketplace — Product Service Layer
// Business logic for product data retrieval via Prisma → Supabase.

import prisma from "../config/db.js";

/**
 * Fetch all products — summary view for marketplace listing.
 * Maps DB field names to camelCase for Flutter consumption.
 */
export async function getAllProducts() {
  const products = await prisma.product.findMany({
    include: {
      variants: {
        orderBy: [{ storage: "asc" }, { color: "asc" }],
      },
      emiPlans: {
        orderBy: { tenureMonths: "asc" },
      },
    },
    orderBy: { createdAt: "asc" },
  });

  return products.map(mapProduct);
}

/**
 * Fetch a single product by slug — full detail for product screen.
 */
export async function getProductBySlug(slug) {
  const product = await prisma.product.findUnique({
    where: { slug },
    include: {
      variants: {
        orderBy: [{ storage: "asc" }, { color: "asc" }],
      },
      emiPlans: {
        orderBy: { tenureMonths: "asc" },
      },
    },
  });

  if (!product) return null;
  return mapProduct(product);
}

/**
 * Fetch variants only for a product by slug.
 */
export async function getVariantsBySlug(slug) {
  const product = await prisma.product.findUnique({
    where: { slug },
    select: { id: true },
  });
  if (!product) return null;

  const variants = await prisma.variant.findMany({
    where: { productId: product.id },
    orderBy: [{ storage: "asc" }, { color: "asc" }],
  });

  return variants.map(mapVariant);
}

/**
 * Fetch EMI plans only for a product by slug.
 */
export async function getEmiPlansBySlug(slug) {
  const product = await prisma.product.findUnique({
    where: { slug },
    select: { id: true },
  });
  if (!product) return null;

  const plans = await prisma.emiPlan.findMany({
    where: { productId: product.id },
    orderBy: { tenureMonths: "asc" },
  });

  return plans.map(mapEmiPlan);
}

// ─── Mappers — DB rows → Flutter-friendly JSON ────────────────────────────

function mapProduct(p) {
  return {
    id: String(p.id),
    name: p.name,
    slug: p.slug,
    brand: p.brand ?? "",
    description: p.description ?? "",
    category: p.category ?? "",
    imageUrl: p.image,           // Flutter model uses imageUrl
    mrp: p.mrp,
    basePrice: p.price,          // Flutter model uses basePrice
    rating: p.rating,
    reviewCount: p.reviewCount,
    badges: p.badges ?? [],
    variants: (p.variants ?? []).map(mapVariant),
    emiPlans: (p.emiPlans ?? []).map(mapEmiPlan),
  };
}

function mapVariant(v) {
  return {
    id: String(v.id),
    productId: String(v.productId),
    storage: v.storage ?? "N/A",
    color: v.color ?? "",
    colorHex: v.colorHex ?? "#9E9E9E",
    finish: v.finish ?? "",
    price: v.price,
    mrp: v.mrp > 0 ? v.mrp : v.price,
    imageUrl: v.image ?? "",     // Flutter model uses imageUrl
    inStock: v.inStock,
  };
}

function mapEmiPlan(e) {
  return {
    id: String(e.id),
    productId: String(e.productId),
    monthlyAmount: e.monthlyAmount,
    tenureMonths: e.tenureMonths,
    interestRate: e.interestRate,
    cashback: e.cashback,
    tag: e.tag ?? "",
    bankName: e.bankName ?? "1Fi Credit",
  };
}
