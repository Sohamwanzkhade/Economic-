-- Table volumes
SELECT 'customers' table_name, COUNT(*) row_count FROM staging.customers
UNION ALL SELECT 'orders', COUNT(*) FROM staging.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM staging.order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM staging.order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM staging.order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM staging.products
UNION ALL SELECT 'sellers', COUNT(*) FROM staging.sellers;

-- Orphan relationships
SELECT COUNT(*) AS items_without_order
FROM staging.order_items i LEFT JOIN staging.orders o USING(order_id)
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orders_without_customer
FROM staging.orders o LEFT JOIN staging.customers c USING(customer_id)
WHERE c.customer_id IS NULL;

-- Status mix and source date coverage
SELECT order_status, COUNT(*) orders
FROM staging.orders GROUP BY order_status ORDER BY orders DESC;

SELECT MIN(order_purchase_timestamp) first_order,
       MAX(order_purchase_timestamp) last_order,
       COUNT(*) FILTER(WHERE order_purchase_timestamp IS NULL) missing_purchase_dates
FROM staging.orders;
