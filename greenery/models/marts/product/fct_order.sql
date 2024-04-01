{{ config(materialized='table') }}

WITH order_items AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__order_items')}}
),

orders AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__orders')}}
),

products AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__products')}}
)

SELECT 
    order_items.order_id,
    order_items.product_quantity,
    products.product_price AS unit_price,
    orders.order_created_at_utc
FROM order_items
LEFT JOIN orders
    ON order_items.order_id = orders.order_id
LEFT JOIN products
    ON order_items.product_id = products.product_id