{{ config(materialized='view') }}

WITH orders AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__orders') }}
),

max_date AS (
    SELECT
        MAX(order_created_at_utc) AS max_created_at
    FROM orders
)

SELECT
    user_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN order_created_at_utc >= max_date.max_created_at - INTERVAL '30 days' THEN 1 END) AS orders_last_30_days,
    COUNT(CASE WHEN order_created_at_utc >= max_date.max_created_at - INTERVAL '90 days' THEN 1 END) AS orders_last_90_days,
    COUNT(CASE WHEN order_created_at_utc >= max_date.max_created_at - INTERVAL '365 days' THEN 1 END) AS orders_last_365_days,
    (COUNT(*) = 1)::INT AS single_order_flag,
    (COUNT(*) >= 2)::INT AS multiple_orders_flag,
    SUM(order_cost) AS total_order_cost,
    AVG(order_cost) AS average_order_cost,
    SUM(shipping_cost) AS total_shipping_cost,
    AVG(shipping_cost) AS average_shipping_cost,
    SUM(order_total) AS total_cost,
    AVG(order_total) AS average_cost,
    COUNT(promo_id) AS total_promos,
    DIV0(COUNT(promo_id), COUNT(*)) AS promo_use_rate,
    MIN(order_created_at_utc) AS first_order_date_utc,
    MAX(order_created_at_utc) AS last_order_date_utc
FROM orders
CROSS JOIN max_date
GROUP BY user_id