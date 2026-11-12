CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.customers (
 customer_id TEXT PRIMARY KEY, customer_unique_id TEXT,
 customer_zip_code_prefix INTEGER, customer_city TEXT, customer_state CHAR(2)
);
CREATE TABLE IF NOT EXISTS staging.orders (
 order_id TEXT PRIMARY KEY, customer_id TEXT, order_status TEXT,
 order_purchase_timestamp TIMESTAMP, order_approved_at TIMESTAMP,
 order_delivered_carrier_date TIMESTAMP, order_delivered_customer_date TIMESTAMP,
 order_estimated_delivery_date TIMESTAMP
);
CREATE TABLE IF NOT EXISTS staging.order_items (
 order_id TEXT, order_item_id INTEGER, product_id TEXT, seller_id TEXT,
 shipping_limit_date TIMESTAMP, price NUMERIC(12,2), freight_value NUMERIC(12,2),
 PRIMARY KEY(order_id, order_item_id)
);
CREATE TABLE IF NOT EXISTS staging.order_payments (
 order_id TEXT, payment_sequential INTEGER, payment_type TEXT,
 payment_installments INTEGER, payment_value NUMERIC(12,2),
 PRIMARY KEY(order_id, payment_sequential)
);
CREATE TABLE IF NOT EXISTS staging.order_reviews (
 review_id TEXT, order_id TEXT, review_score INTEGER,
 review_comment_title TEXT, review_comment_message TEXT,
 review_creation_date TIMESTAMP, review_answer_timestamp TIMESTAMP
);
CREATE TABLE IF NOT EXISTS staging.products (
 product_id TEXT PRIMARY KEY, product_category_name TEXT,
 product_name_length INTEGER, product_description_length INTEGER,
 product_photos_qty INTEGER, product_weight_g INTEGER,
 product_length_cm INTEGER, product_height_cm INTEGER, product_width_cm INTEGER
);
CREATE TABLE IF NOT EXISTS staging.sellers (
 seller_id TEXT PRIMARY KEY, seller_zip_code_prefix INTEGER,
 seller_city TEXT, seller_state CHAR(2)
);
CREATE TABLE IF NOT EXISTS staging.product_category_name_translation (
 product_category_name TEXT PRIMARY KEY, product_category_name_english TEXT
);
-- ZIP prefixes may have multiple coordinates: do not impose a false unique key.
CREATE TABLE IF NOT EXISTS staging.geolocation (
 geolocation_zip_code_prefix INTEGER, geolocation_lat DOUBLE PRECISION,
 geolocation_lng DOUBLE PRECISION, geolocation_city TEXT, geolocation_state CHAR(2)
);

CREATE INDEX IF NOT EXISTS ix_orders_customer ON staging.orders(customer_id);
CREATE INDEX IF NOT EXISTS ix_orders_purchase_ts ON staging.orders(order_purchase_timestamp);
CREATE INDEX IF NOT EXISTS ix_items_product ON staging.order_items(product_id);
CREATE INDEX IF NOT EXISTS ix_items_seller ON staging.order_items(seller_id);
CREATE INDEX IF NOT EXISTS ix_payments_order ON staging.order_payments(order_id);
CREATE INDEX IF NOT EXISTS ix_reviews_order ON staging.order_reviews(order_id);
