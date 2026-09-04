// 1Fi Marketplace Backend - Express Server Entry Point

import "dotenv/config";
import express from "express";
import cors from "cors";
import productRoutes from "./routes/productRoutes.js";
import { errorHandler, notFound } from "./middleware/errorHandler.js";

const app = express();
const PORT = process.env.PORT || 3000;
const FRONTEND_URL = process.env.FRONTEND_URL || "http://localhost:5173";

// ─── Middleware ───────────────────────────────
app.use(
  cors({
    origin: [FRONTEND_URL, "http://localhost:5173", "http://localhost:4173"],
    methods: ["GET", "POST"],
    credentials: true,
  })
);
app.use(express.json());

// ─── Health Check ────────────────────────────
app.get("/api/health", (_req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
  });
});

// ─── API Routes ──────────────────────────────
app.use("/api/products", productRoutes);

// ─── Error Handling ──────────────────────────
app.use(notFound);
app.use(errorHandler);

// ─── Start Server ────────────────────────────
app.listen(PORT, () => {
  console.log(`🚀 1Fi Marketplace API running on http://localhost:${PORT}`);
  console.log(`📋 Health check: http://localhost:${PORT}/api/health`);
  console.log(`📦 Products API: http://localhost:${PORT}/api/products`);
});

export default app;
