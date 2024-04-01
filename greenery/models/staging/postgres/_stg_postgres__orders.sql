WITH orders_source AS (
    SELECT 
        *
    FROM {{ source('postgres', 'orders') }}
)

SELECT 
    order_id,
    promo_id,
    user_id,
    address_id AS shipping_address_id,
    created_at AS order_created_at_utc,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at AS estimated_delivery_at_utc,
    delivered_at AS delivered_at_utc,
    status AS order_status
FROM orders_source