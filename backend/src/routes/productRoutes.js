// 1Fi Marketplace - Product Routes
// Defines REST API routes for product-related operations.

import { Router } from "express";
import {
  listProducts,
  getProduct,
  getVariants,
  getEmiPlans,
} from "../controllers/productController.js";

const router = Router();

// GET /api/products — List all products
router.get("/", listProducts);

// GET /api/products/:slug — Get single product details
router.get("/:slug", getProduct);

// GET /api/products/:slug/variants — Get variants for a product
router.get("/:slug/variants", getVariants);

// GET /api/products/:slug/emi-plans — Get EMI plans for a product
router.get("/:slug/emi-plans", getEmiPlans);

export default router;
