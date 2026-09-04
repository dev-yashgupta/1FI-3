// 1Fi Marketplace - Database Seed Script
// Seeds the database with demonstration product, variant, and EMI plan data.
// NOTE: This is demonstration/seed data only. It does not represent actual 1Fi commercial offerings.

import { PrismaClient } from "../generated/prisma/client.js";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Seeding database...");

  // Clear existing data
  await prisma.emiPlan.deleteMany();
  await prisma.variant.deleteMany();
  await prisma.product.deleteMany();

  // ─────────────────────────────────────────────
  // Product 1: iPhone 17 Pro
  // ─────────────────────────────────────────────
  const iphone = await prisma.product.create({
    data: {
      name: "iPhone 17 Pro",
      slug: "iphone-17-pro",
      description:
        "The iPhone 17 Pro features a stunning titanium design, A19 Pro chip, 48MP camera system with 5x optical zoom, and the all-new Camera Control button.",
      brand: "Apple",
      category: "Smartphones",
      mrp: 134900,
      price: 127400,
      image:
        "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-hero-desert-202409?wid=940&hei=1112&fmt=png-alpha",
      variants: {
        create: [
          {
            color: "Natural Titanium",
            storage: "256 GB",
            price: 127400,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "White Titanium",
            storage: "256 GB",
            price: 127400,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-whitetitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "Black Titanium",
            storage: "256 GB",
            price: 127400,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-blacktitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "Desert Titanium",
            storage: "256 GB",
            price: 127400,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-deserttitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "Natural Titanium",
            storage: "512 GB",
            price: 144900,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "Black Titanium",
            storage: "512 GB",
            price: 144900,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-blacktitanium?wid=940&hei=1112&fmt=png-alpha",
          },
          {
            color: "Natural Titanium",
            storage: "1 TB",
            price: 174900,
            image:
              "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha",
          },
        ],
      },
      emiPlans: {
        create: [
          {
            monthlyAmount: 42467,
            tenureMonths: 3,
            interestRate: 0,
            cashback: 7500,
          },
          {
            monthlyAmount: 21233,
            tenureMonths: 6,
            interestRate: 0,
            cashback: 7500,
          },
          {
            monthlyAmount: 10617,
            tenureMonths: 12,
            interestRate: 0,
            cashback: 7500,
          },
          {
            monthlyAmount: 5800,
            tenureMonths: 24,
            interestRate: 8.5,
            cashback: 5000,
          },
          {
            monthlyAmount: 4100,
            tenureMonths: 36,
            interestRate: 10.5,
            cashback: 3500,
          },
        ],
      },
    },
  });

  // ─────────────────────────────────────────────
  // Product 2: Samsung Galaxy S24 Ultra
  // ─────────────────────────────────────────────
  const samsung = await prisma.product.create({
    data: {
      name: "Samsung Galaxy S24 Ultra",
      slug: "samsung-galaxy-s24-ultra",
      description:
        "Galaxy S24 Ultra features a 6.8\" QHD+ Dynamic AMOLED 2X display, Snapdragon 8 Gen 3, 200MP camera, and Galaxy AI built in.",
      brand: "Samsung",
      category: "Smartphones",
      mrp: 129999,
      price: 109999,
      image:
        "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462",
      variants: {
        create: [
          {
            color: "Titanium Black",
            storage: "256 GB",
            price: 109999,
            image:
              "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462",
          },
          {
            color: "Titanium Gray",
            storage: "256 GB",
            price: 109999,
            image:
              "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzkdins-thumb-539572458",
          },
          {
            color: "Titanium Violet",
            storage: "256 GB",
            price: 109999,
            image:
              "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzvdins-thumb-539572466",
          },
          {
            color: "Titanium Black",
            storage: "512 GB",
            price: 124999,
            image:
              "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462",
          },
          {
            color: "Titanium Violet",
            storage: "512 GB",
            price: 124999,
            image:
              "https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzvdins-thumb-539572466",
          },
        ],
      },
      emiPlans: {
        create: [
          {
            monthlyAmount: 36666,
            tenureMonths: 3,
            interestRate: 0,
            cashback: 5000,
          },
          {
            monthlyAmount: 18333,
            tenureMonths: 6,
            interestRate: 0,
            cashback: 5000,
          },
          {
            monthlyAmount: 9167,
            tenureMonths: 12,
            interestRate: 0,
            cashback: 5000,
          },
          {
            monthlyAmount: 5000,
            tenureMonths: 24,
            interestRate: 8.5,
            cashback: 3000,
          },
          {
            monthlyAmount: 3550,
            tenureMonths: 36,
            interestRate: 10.5,
            cashback: 2000,
          },
        ],
      },
    },
  });

  // ─────────────────────────────────────────────
  // Product 3: Google Pixel 10 Pro
  // ─────────────────────────────────────────────
  const pixel = await prisma.product.create({
    data: {
      name: "Google Pixel 10 Pro",
      slug: "google-pixel-10-pro",
      description:
        "Pixel 10 Pro features Google's Tensor G5 chip, 50MP triple camera with Magic Eraser and Best Take, a brilliant 6.7\" LTPO OLED display, and 7 years of OS updates.",
      brand: "Google",
      category: "Smartphones",
      mrp: 99999,
      price: 89999,
      image:
        "https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ",
      variants: {
        create: [
          {
            color: "Obsidian",
            storage: "256 GB",
            price: 89999,
            image:
              "https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ",
          },
          {
            color: "Porcelain",
            storage: "256 GB",
            price: 89999,
            image:
              "https://lh3.googleusercontent.com/4N4bxae3C7sThdOw6wFMREvNjb1KTi3CcSf8OD_E_1u6SDi-rrL7aM7_g12R5_4RGIhefSM7XBMqK4yJnE-7VVptj7v5Fm4Y",
          },
          {
            color: "Hazel",
            storage: "256 GB",
            price: 89999,
            image:
              "https://lh3.googleusercontent.com/zqoTaT8jLqCSN0tJT8gahFNqEVqE3BNHoTJb-9tGBSyqAtNY6lYqjJ7bGgpInGdzcVlvA-kLjZxN9WUQqC-M9H7hHMFTxhr5g",
          },
          {
            color: "Obsidian",
            storage: "512 GB",
            price: 104999,
            image:
              "https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ",
          },
          {
            color: "Porcelain",
            storage: "512 GB",
            price: 104999,
            image:
              "https://lh3.googleusercontent.com/4N4bxae3C7sThdOw6wFMREvNjb1KTi3CcSf8OD_E_1u6SDi-rrL7aM7_g12R5_4RGIhefSM7XBMqK4yJnE-7VVptj7v5Fm4Y",
          },
        ],
      },
      emiPlans: {
        create: [
          {
            monthlyAmount: 30000,
            tenureMonths: 3,
            interestRate: 0,
            cashback: 4000,
          },
          {
            monthlyAmount: 15000,
            tenureMonths: 6,
            interestRate: 0,
            cashback: 4000,
          },
          {
            monthlyAmount: 7500,
            tenureMonths: 12,
            interestRate: 0,
            cashback: 4000,
          },
          {
            monthlyAmount: 4100,
            tenureMonths: 24,
            interestRate: 8.5,
            cashback: 2500,
          },
          {
            monthlyAmount: 2900,
            tenureMonths: 36,
            interestRate: 10.5,
            cashback: 1500,
          },
        ],
      },
    },
  });

  console.log(`✅ Created products:`);
  console.log(`   - ${iphone.name} (${iphone.slug})`);
  console.log(`   - ${samsung.name} (${samsung.slug})`);
  console.log(`   - ${pixel.name} (${pixel.slug})`);
  console.log("🌱 Seeding complete!");
}

main()
  .catch((e) => {
    console.error("❌ Seeding failed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
