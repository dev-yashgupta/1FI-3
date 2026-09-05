// 1Fi Marketplace Backend — Express Server Entry Point

import "dotenv/config";
import express from "express";
import cors from "cors";
import productRoutes from "./routes/productRoutes.js";
import { errorHandler, notFound } from "./middleware/errorHandler.js";

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ───────────────────────────────────────────────────────────────
app.use(cors()); // Allow all origins (Flutter mobile, emulator, web)
app.use(express.json());

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get("/api/health", (_req, res) => {
  res.json({
    status: "ok",
    service: "1Fi Marketplace API",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
    database: "Supabase PostgreSQL",
  });
});

// ─── API Routes ───────────────────────────────────────────────────────────────
app.use("/api/products", productRoutes);

// ─── Error Handling ───────────────────────────────────────────────────────────
app.use(notFound);
app.use(errorHandler);

// ─── Start Server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 1Fi Marketplace API`);
  console.log(`   http://localhost:${PORT}`);
  console.log(`   Health : http://localhost:${PORT}/api/health`);
  console.log(`   Products: http://localhost:${PORT}/api/products\n`);
});

export default app;
