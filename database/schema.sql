-- =============================================
-- 1Fi Marketplace - PostgreSQL Database Schema
-- =============================================
-- This schema defines the normalized database structure for the 1Fi Marketplace.
-- Run this file to create the tables if not using Prisma migrations.
-- =============================================

-- Products table
CREATE TABLE IF NOT EXISTS products (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(255) NOT NULL,
  slug          VARCHAR(255) NOT NULL UNIQUE,
  description   TEXT,
  brand         VARCHAR(100),
  category      VARCHAR(100),
  mrp           DOUBLE PRECISION NOT NULL,
  price         DOUBLE PRECISION NOT NULL,
  image         TEXT NOT NULL,
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on slug for fast lookups
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);

-- Variants table
CREATE TABLE IF NOT EXISTS variants (
  id            SERIAL PRIMARY KEY,
  product_id    INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  color         VARCHAR(100),
  storage       VARCHAR(50),
  finish        VARCHAR(100),
  price         DOUBLE PRECISION NOT NULL,
  image         TEXT,
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on product_id for fast joins
CREATE INDEX IF NOT EXISTS idx_variants_product_id ON variants(product_id);

-- EMI Plans table
CREATE TABLE IF NOT EXISTS emi_plans (
  id              SERIAL PRIMARY KEY,
  product_id      INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  monthly_amount  DOUBLE PRECISION NOT NULL,
  tenure_months   INTEGER NOT NULL,
  interest_rate   DOUBLE PRECISION NOT NULL,
  cashback        DOUBLE PRECISION DEFAULT 0,
  created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on product_id for fast joins
CREATE INDEX IF NOT EXISTS idx_emi_plans_product_id ON emi_plans(product_id);
