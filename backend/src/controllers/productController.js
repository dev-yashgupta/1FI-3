// 1Fi Marketplace - Product Controller
// Handles HTTP request/response for product-related endpoints.

import {
  getAllProducts,
  getProductBySlug,
  getVariantsBySlug,
  getEmiPlansBySlug,
} from "../services/productService.js";

/**
 * GET /api/products
 * Returns all products (summary view for the marketplace listing)
 */
export async function listProducts(req, res, next) {
  try {
    const products = await getAllProducts();
    res.json(products);
  } catch (error) {
    next(error);
  }
}

/**
 * GET /api/products/:slug
 * Returns a single product with variants and EMI plans
 */
export async function getProduct(req, res, next) {
  try {
    const { slug } = req.params;

    if (!slug || typeof slug !== "string") {
      res.status(400);
      return next(new Error("Invalid product slug"));
    }

    const product = await getProductBySlug(slug);

    if (!product) {
      res.status(404);
      return next(new Error(`Product not found: ${slug}`));
    }

    res.json(product);
  } catch (error) {
    next(error);
  }
}

/**
 * GET /api/products/:slug/variants
 * Returns variants for a single product
 */
export async function getVariants(req, res, next) {
  try {
    const { slug } = req.params;
    const variants = await getVariantsBySlug(slug);

    if (!variants) {
      res.status(404);
      return next(new Error(`Product not found: ${slug}`));
    }

    res.json(variants);
  } catch (error) {
    next(error);
  }
}

/**
 * GET /api/products/:slug/emi-plans
 * Returns EMI plans for a single product
 */
export async function getEmiPlans(req, res, next) {
  try {
    const { slug } = req.params;
    const emiPlans = await getEmiPlansBySlug(slug);

    if (!emiPlans) {
      res.status(404);
      return next(new Error(`Product not found: ${slug}`));
    }

    res.json(emiPlans);
  } catch (error) {
    next(error);
  }
}
