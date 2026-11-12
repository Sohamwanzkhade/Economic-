-- Monthly merchandise sales and freight, at order grain.
WITH order_value AS (
 SELECT order_id, SUM(price) merchandise_sales, SUM(freight_value) freight_charged
 FROM staging.order_items GROUP BY order_id
)
SELECT DATE_TRUNC('month',o.order_purchase_timestamp)::date purchase_month,
       COUNT(DISTINCT o.order_id) order_count,
       SUM(v.merchandise_sales) merchandise_sales,
       SUM(v.freight_charged) freight_charged,
       AVG(v.merchandise_sales) avg_order_merchandise_value
FROM staging.orders o JOIN order_value v USING(order_id)
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1 ORDER BY 1;

-- Top product categories
SELECT COALESCE(t.product_category_name_english,p.product_category_name,'unknown') category,
       COUNT(DISTINCT i.order_id) orders,
       SUM(i.price) merchandise_sales,
       SUM(i.freight_value) freight_charged
FROM staging.order_items i
JOIN staging.products p USING(product_id)
LEFT JOIN staging.product_category_name_translation t USING(product_category_name)
GROUP BY 1 ORDER BY merchandise_sales DESC LIMIT 20;

-- Late-delivery rate; denominator includes only delivered orders with both dates.
SELECT COUNT(*) eligible_delivered_orders,
       COUNT(*) FILTER(WHERE order_delivered_customer_date>order_estimated_delivery_date) late_orders,
       ROUND(100.0*COUNT(*) FILTER(WHERE order_delivered_customer_date>order_estimated_delivery_date)
         /NULLIF(COUNT(*),0),2) late_delivery_pct
FROM staging.orders
WHERE order_status='delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;
