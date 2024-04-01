WITH products_source AS (
    SELECT
        *
    FROM 
        {{ source('postgres', 'products') }}
)

SELECT 
    product_id,
    name AS product_name,
    price AS product_price,
    inventory AS product_inventory_level
FROM products_source