-- =============================================
-- 1Fi Marketplace - Seed Data
-- =============================================
-- IMPORTANT: This is demonstration/seed data only.
-- It does not represent actual 1Fi commercial offerings.
-- =============================================

-- Clear existing data (in reverse dependency order)
DELETE FROM emi_plans;
DELETE FROM variants;
DELETE FROM products;

-- ─────────────────────────────────────────────
-- Product 1: iPhone 17 Pro
-- ─────────────────────────────────────────────
INSERT INTO products (name, slug, description, brand, category, mrp, price, image)
VALUES (
  'iPhone 17 Pro',
  'iphone-17-pro',
  'The iPhone 17 Pro features a stunning titanium design, A19 Pro chip, 48MP camera system with 5x optical zoom, and the all-new Camera Control button.',
  'Apple',
  'Smartphones',
  134900,
  127400,
  'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-hero-desert-202409?wid=940&hei=1112&fmt=png-alpha'
);

-- iPhone variants
INSERT INTO variants (product_id, color, storage, price, image) VALUES
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Natural Titanium', '256 GB', 127400, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'White Titanium', '256 GB', 127400, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-whitetitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Black Titanium', '256 GB', 127400, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-blacktitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Desert Titanium', '256 GB', 127400, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-deserttitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Natural Titanium', '512 GB', 144900, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Black Titanium', '512 GB', 144900, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-blacktitanium?wid=940&hei=1112&fmt=png-alpha'),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 'Natural Titanium', '1 TB', 174900, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium?wid=940&hei=1112&fmt=png-alpha');

-- iPhone EMI plans
INSERT INTO emi_plans (product_id, monthly_amount, tenure_months, interest_rate, cashback) VALUES
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 42467, 3, 0, 7500),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 21233, 6, 0, 7500),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 10617, 12, 0, 7500),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 5800, 24, 8.5, 5000),
  ((SELECT id FROM products WHERE slug = 'iphone-17-pro'), 4100, 36, 10.5, 3500);

-- ─────────────────────────────────────────────
-- Product 2: Samsung Galaxy S24 Ultra
-- ─────────────────────────────────────────────
INSERT INTO products (name, slug, description, brand, category, mrp, price, image)
VALUES (
  'Samsung Galaxy S24 Ultra',
  'samsung-galaxy-s24-ultra',
  'Galaxy S24 Ultra features a 6.8" QHD+ Dynamic AMOLED 2X display, Snapdragon 8 Gen 3, 200MP camera, and Galaxy AI built in.',
  'Samsung',
  'Smartphones',
  129999,
  109999,
  'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462'
);

-- Samsung variants
INSERT INTO variants (product_id, color, storage, price, image) VALUES
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 'Titanium Black', '256 GB', 109999, 'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462'),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 'Titanium Gray', '256 GB', 109999, 'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzkdins-thumb-539572458'),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 'Titanium Violet', '256 GB', 109999, 'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzvdins-thumb-539572466'),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 'Titanium Black', '512 GB', 124999, 'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bztdins-thumb-539572462'),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 'Titanium Violet', '512 GB', 124999, 'https://images.samsung.com/is/image/samsung/p6pim/in/2401/gallery/in-galaxy-s24-ultra-s928-sm-s928bzvdins-thumb-539572466');

-- Samsung EMI plans
INSERT INTO emi_plans (product_id, monthly_amount, tenure_months, interest_rate, cashback) VALUES
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 36666, 3, 0, 5000),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 18333, 6, 0, 5000),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 9167, 12, 0, 5000),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 5000, 24, 8.5, 3000),
  ((SELECT id FROM products WHERE slug = 'samsung-galaxy-s24-ultra'), 3550, 36, 10.5, 2000);

-- ─────────────────────────────────────────────
-- Product 3: Google Pixel 10 Pro
-- ─────────────────────────────────────────────
INSERT INTO products (name, slug, description, brand, category, mrp, price, image)
VALUES (
  'Google Pixel 10 Pro',
  'google-pixel-10-pro',
  'Pixel 10 Pro features Google''s Tensor G5 chip, 50MP triple camera with Magic Eraser and Best Take, a brilliant 6.7" LTPO OLED display, and 7 years of OS updates.',
  'Google',
  'Smartphones',
  99999,
  89999,
  'https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ'
);

-- Pixel variants
INSERT INTO variants (product_id, color, storage, price, image) VALUES
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 'Obsidian', '256 GB', 89999, 'https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ'),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 'Porcelain', '256 GB', 89999, 'https://lh3.googleusercontent.com/4N4bxae3C7sThdOw6wFMREvNjb1KTi3CcSf8OD_E_1u6SDi-rrL7aM7_g12R5_4RGIhefSM7XBMqK4yJnE-7VVptj7v5Fm4Y'),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 'Hazel', '256 GB', 89999, 'https://lh3.googleusercontent.com/zqoTaT8jLqCSN0tJT8gahFNqEVqE3BNHoTJb-9tGBSyqAtNY6lYqjJ7bGgpInGdzcVlvA-kLjZxN9WUQqC-M9H7hHMFTxhr5g'),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 'Obsidian', '512 GB', 104999, 'https://lh3.googleusercontent.com/477jSaSx_rGiPxnOJkWB5VhEr4IFvsYw84VkrB2aFSy-XTg1eMu5lA78v-eIYr7PlmQ3BLDY1p3GgJqBjt_eP9u5vFYDLOjhNQ'),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 'Porcelain', '512 GB', 104999, 'https://lh3.googleusercontent.com/4N4bxae3C7sThdOw6wFMREvNjb1KTi3CcSf8OD_E_1u6SDi-rrL7aM7_g12R5_4RGIhefSM7XBMqK4yJnE-7VVptj7v5Fm4Y');

-- Pixel EMI plans
INSERT INTO emi_plans (product_id, monthly_amount, tenure_months, interest_rate, cashback) VALUES
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 30000, 3, 0, 4000),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 15000, 6, 0, 4000),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 7500, 12, 0, 4000),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 4100, 24, 8.5, 2500),
  ((SELECT id FROM products WHERE slug = 'google-pixel-10-pro'), 2900, 36, 10.5, 1500);
