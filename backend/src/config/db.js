// 1Fi Marketplace - Prisma Client Singleton
// Ensures a single PrismaClient instance is reused across the application.

import { PrismaClient } from "../../generated/prisma/client.js";

const prisma = new PrismaClient({
  log: process.env.NODE_ENV === "development" ? ["query", "error", "warn"] : ["error"],
});

export default prisma;
