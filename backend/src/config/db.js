// 1Fi Marketplace — Prisma Client Singleton
// Connects to Supabase PostgreSQL via DATABASE_URL in .env

import { PrismaClient } from "../../generated/prisma/index.js";

const prisma = new PrismaClient({
  log:
    process.env.NODE_ENV === "development"
      ? ["query", "error", "warn"]
      : ["error"],
});

export default prisma;
