// 1Fi Marketplace — Prisma 7 Client Singleton
// Prisma 7 requires passing the datasource URL to the constructor.

import "dotenv/config";
import { PrismaClient } from "../../generated/prisma/index.js";

if (!process.env.DATABASE_URL) {
  throw new Error(
    "DATABASE_URL is not set. Run: powershell -File setup_env.ps1"
  );
}

const prisma = new PrismaClient({
  datasourceUrl: process.env.DATABASE_URL,
  log:
    process.env.NODE_ENV === "development"
      ? ["query", "error", "warn"]
      : ["error"],
});

export default prisma;
