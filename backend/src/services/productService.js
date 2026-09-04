// 1Fi Marketplace - Product Service Layer
// Business logic for product data retrieval, separated from route handlers.

import prisma from "../config/db.js";

/**
 * Fetch all products (summary view for marketplace listing)
 */
export async function getAllProducts() {
  const products = await prisma.product.findMany({
    select: {
      id: true,
      name: true,
      slug: true,
      brand: true,
      category: true,
      mrp: true,
      price: true,
      image: true,
      description: true,
      variants: {
        select: {
          id: true,
          color: true,
          storage: true,
          price: true,
        },
        distinct: ["storage"],
        orderBy: { price: "asc" },
      },
      emiPlans: {
        select: {
          id: true,
          monthlyAmount: true,
          tenureMonths: true,
        },
        orderBy: { tenureMonths: "asc" },
        take: 1,
      },
    },
    orderBy: { createdAt: "asc" },
  });

  return products;
}

/**
 * Fetch a single product by slug, including full variants and EMI plans
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

  return product;
}

/**
 * Fetch variants for a product by slug
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

  return variants;
}

/**
 * Fetch EMI plans for a product by slug
 */
export async function getEmiPlansBySlug(slug) {
  const product = await prisma.product.findUnique({
    where: { slug },
    select: { id: true },
  });

  if (!product) return null;

  const emiPlans = await prisma.emiPlan.findMany({
    where: { productId: product.id },
    orderBy: { tenureMonths: "asc" },
  });

  return emiPlans;
}
