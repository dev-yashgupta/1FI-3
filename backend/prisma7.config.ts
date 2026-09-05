// Prisma 7 config — connection URLs live HERE, not in schema.prisma
import "dotenv/config";
import { defineConfig } from "prisma/config";

export default defineConfig({
  schema: "prisma/schema.prisma",
  datasource: {
    url: process.env["DATABASE_URL"]!,
    // directUrl used by migrate/push to bypass the connection pooler
    // @ts-ignore — Prisma 7 supports this on the datasource object
    directUrl: process.env["DIRECT_URL"],
  },
});
