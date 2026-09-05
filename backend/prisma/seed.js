// 1Fi Marketplace — Database Seed Script
// NOTE: All data is demonstration only. Not actual 1Fi commercial offerings.

import { PrismaClient } from "../generated/prisma/index.js";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Seeding 1Fi Marketplace...\n");

  // Clear existing data
  await prisma.emiPlan.deleteMany();
  await prisma.variant.deleteMany();
  await prisma.product.deleteMany();
  console.log("🗑️  Cleared existing data");

  // ── 1: iPhone 17 Pro ────────────────────────────────────────────────────
  const iphone = await prisma.product.create({
    data: {
      name: "iPhone 17 Pro",
      slug: "iphone-17-pro",
      description: "The most advanced iPhone yet. Featuring the A19 Pro chip, a stunning ProMotion display, and a pro-grade camera system with periscope telephoto.",
      brand: "Apple",
      category: "Smartphones",
      mrp: 134900, price: 127400,
      image: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&q=80",
      rating: 4.8, reviewCount: 2341,
      badges: ["No-cost EMI", "Free delivery"],
      variants: {
        create: [
          { storage: "256 GB", color: "Natural Titanium", colorHex: "#C5B9A8", finish: "Titanium", price: 127400, mrp: 134900, image: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&q=80", inStock: true },
          { storage: "256 GB", color: "Desert Titanium",  colorHex: "#C8A882", finish: "Titanium", price: 127400, mrp: 134900, image: "https://images.unsplash.com/photo-1711463369546-46de27e6fcd8?w=600&q=80", inStock: true },
          { storage: "512 GB", color: "Black Titanium",   colorHex: "#3A3A3C", finish: "Titanium", price: 145900, mrp: 154900, image: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&q=80", inStock: true },
          { storage: "1 TB",   color: "White Titanium",   colorHex: "#F5F5F0", finish: "Titanium", price: 164900, mrp: 174900, image: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&q=80", inStock: false },
        ],
      },
      emiPlans: {
        create: [
          { tenureMonths: 3,  monthlyAmount: 44967, interestRate: 0,    cashback: 7500, tag: "Best Value", bankName: "1Fi Credit" },
          { tenureMonths: 6,  monthlyAmount: 22483, interestRate: 0,    cashback: 7500, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 12, monthlyAmount: 11242, interestRate: 0,    cashback: 7500, tag: "Popular",    bankName: "1Fi Credit" },
          { tenureMonths: 24, monthlyAmount: 5621,  interestRate: 0,    cashback: 7500, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 36, monthlyAmount: 4297,  interestRate: 10.5, cashback: 7500, tag: "",           bankName: "1Fi Credit" },
        ],
      },
    },
  });

  // ── 2: Samsung Galaxy S25 Ultra ──────────────────────────────────────────
  const samsung = await prisma.product.create({
    data: {
      name: "Samsung Galaxy S25 Ultra",
      slug: "samsung-galaxy-s25-ultra",
      description: "Engineered for those who demand the best. Integrated S Pen, Snapdragon 8 Elite processor, and a 200MP quad-camera system.",
      brand: "Samsung",
      category: "Smartphones",
      mrp: 129999, price: 119999,
      image: "https://images.unsplash.com/photo-1706232941662-b91d1e5dca4d?w=600&q=80",
      rating: 4.7, reviewCount: 1876,
      badges: ["No-cost EMI", "Exchange offer"],
      variants: {
        create: [
          { storage: "256 GB", color: "Titanium Black",      colorHex: "#2C2C2E", finish: "Matte", price: 119999, mrp: 129999, image: "https://images.unsplash.com/photo-1706232941662-b91d1e5dca4d?w=600&q=80", inStock: true  },
          { storage: "256 GB", color: "Titanium Gray",       colorHex: "#8E8E93", finish: "Matte", price: 119999, mrp: 129999, image: "https://images.unsplash.com/photo-1706232941662-b91d1e5dca4d?w=600&q=80", inStock: true  },
          { storage: "512 GB", color: "Titanium Violet",     colorHex: "#7B68EE", finish: "Matte", price: 137999, mrp: 149999, image: "https://images.unsplash.com/photo-1706232941662-b91d1e5dca4d?w=600&q=80", inStock: true  },
          { storage: "1 TB",   color: "Titanium Silver Blue",colorHex: "#B0C4DE", finish: "Matte", price: 159999, mrp: 174999, image: "https://images.unsplash.com/photo-1706232941662-b91d1e5dca4d?w=600&q=80", inStock: false },
        ],
      },
      emiPlans: {
        create: [
          { tenureMonths: 3,  monthlyAmount: 39999, interestRate: 0,    cashback: 6000, tag: "Best Value", bankName: "1Fi Credit" },
          { tenureMonths: 6,  monthlyAmount: 19999, interestRate: 0,    cashback: 6000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 12, monthlyAmount: 9999,  interestRate: 0,    cashback: 6000, tag: "Popular",    bankName: "1Fi Credit" },
          { tenureMonths: 24, monthlyAmount: 5416,  interestRate: 0,    cashback: 6000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 36, monthlyAmount: 4166,  interestRate: 10.5, cashback: 6000, tag: "",           bankName: "1Fi Credit" },
        ],
      },
    },
  });

  // ── 3: Google Pixel 9 Pro ────────────────────────────────────────────────
  const pixel = await prisma.product.create({
    data: {
      name: "Google Pixel 9 Pro",
      slug: "google-pixel-9-pro",
      description: "Powered by Google Tensor G4 chip with advanced AI features, best computational photography on Android, and seven years of OS updates.",
      brand: "Google",
      category: "Smartphones",
      mrp: 109999, price: 99999,
      image: "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600&q=80",
      rating: 4.6, reviewCount: 987,
      badges: ["No-cost EMI"],
      variants: {
        create: [
          { storage: "128 GB", color: "Obsidian",  colorHex: "#1C1C1E", finish: "Matte", price: 99999,  mrp: 109999, image: "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600&q=80", inStock: true },
          { storage: "256 GB", color: "Porcelain", colorHex: "#F2EFE9", finish: "Matte", price: 109999, mrp: 119999, image: "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600&q=80", inStock: true },
          { storage: "512 GB", color: "Hazel",     colorHex: "#8B956D", finish: "Matte", price: 124999, mrp: 134999, image: "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600&q=80", inStock: true },
        ],
      },
      emiPlans: {
        create: [
          { tenureMonths: 3,  monthlyAmount: 33333, interestRate: 0,    cashback: 5000, tag: "Best Value", bankName: "1Fi Credit" },
          { tenureMonths: 6,  monthlyAmount: 16666, interestRate: 0,    cashback: 5000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 12, monthlyAmount: 8333,  interestRate: 0,    cashback: 5000, tag: "Popular",    bankName: "1Fi Credit" },
          { tenureMonths: 24, monthlyAmount: 4583,  interestRate: 0,    cashback: 5000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 36, monthlyAmount: 3541,  interestRate: 10.5, cashback: 5000, tag: "",           bankName: "1Fi Credit" },
        ],
      },
    },
  });

  // ── 4: Sony WH-1000XM6 ───────────────────────────────────────────────────
  const sony = await prisma.product.create({
    data: {
      name: "Sony WH-1000XM6",
      slug: "sony-wh-1000xm6",
      description: "Industry-leading noise cancellation. Up to 40 hours battery, multipoint connection, and foldable design for life on the go.",
      brand: "Sony",
      category: "Audio",
      mrp: 34990, price: 29990,
      image: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=600&q=80",
      rating: 4.9, reviewCount: 5420,
      badges: ["No-cost EMI", "Bestseller"],
      variants: {
        create: [
          { storage: "N/A", color: "Black",  colorHex: "#1C1C1E", finish: "Matte",  price: 29990, mrp: 34990, image: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=600&q=80", inStock: true },
          { storage: "N/A", color: "Silver", colorHex: "#C0C0C0", finish: "Glossy", price: 29990, mrp: 34990, image: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=600&q=80", inStock: true },
        ],
      },
      emiPlans: {
        create: [
          { tenureMonths: 3,  monthlyAmount: 9996, interestRate: 0, cashback: 1500, tag: "Best Value", bankName: "1Fi Credit" },
          { tenureMonths: 6,  monthlyAmount: 4998, interestRate: 0, cashback: 1500, tag: "Popular",    bankName: "1Fi Credit" },
          { tenureMonths: 12, monthlyAmount: 2666, interestRate: 0, cashback: 1500, tag: "",           bankName: "1Fi Credit" },
        ],
      },
    },
  });

  // ── 5: MacBook Air M4 ────────────────────────────────────────────────────
  const macbook = await prisma.product.create({
    data: {
      name: "MacBook Air M4",
      slug: "macbook-air-m4",
      description: "Supercharged by M4. Incredibly thin and light with up to 18 hours battery, stunning Liquid Retina display, and zero fan noise.",
      brand: "Apple",
      category: "Laptops",
      mrp: 119900, price: 109900,
      image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80",
      rating: 4.9, reviewCount: 3102,
      badges: ["No-cost EMI", "Free delivery"],
      variants: {
        create: [
          { storage: "256 GB", color: "Midnight",   colorHex: "#1C1C1E", finish: "Aluminium", price: 109900, mrp: 119900, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80", inStock: true  },
          { storage: "512 GB", color: "Starlight",  colorHex: "#F5F5DC", finish: "Aluminium", price: 129900, mrp: 139900, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80", inStock: true  },
          { storage: "512 GB", color: "Sky Blue",   colorHex: "#87CEEB", finish: "Aluminium", price: 129900, mrp: 139900, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80", inStock: true  },
          { storage: "1 TB",   color: "Space Gray", colorHex: "#6E6E73", finish: "Aluminium", price: 149900, mrp: 164900, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80", inStock: false },
        ],
      },
      emiPlans: {
        create: [
          { tenureMonths: 3,  monthlyAmount: 36633, interestRate: 0,    cashback: 5000, tag: "Best Value", bankName: "1Fi Credit" },
          { tenureMonths: 6,  monthlyAmount: 18316, interestRate: 0,    cashback: 5000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 12, monthlyAmount: 9158,  interestRate: 0,    cashback: 5000, tag: "Popular",    bankName: "1Fi Credit" },
          { tenureMonths: 24, monthlyAmount: 4991,  interestRate: 0,    cashback: 5000, tag: "",           bankName: "1Fi Credit" },
          { tenureMonths: 36, monthlyAmount: 3841,  interestRate: 10.5, cashback: 5000, tag: "",           bankName: "1Fi Credit" },
        ],
      },
    },
  });

  console.log("\n✅ Seeded:");
  for (const p of [iphone, samsung, pixel, sony, macbook]) {
    console.log(`   ✓ ${p.name} (${p.slug})`);
  }
  console.log("\n🌱 Done!");
}

main()
  .catch((e) => {
    console.error("\n❌ Seed failed:", e.message);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
