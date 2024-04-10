{{ 
    config(
        materialized='table',
        post_hook=[
            "{{ grant('reporting') }}"
        ]  
    )  
}}

WITH users AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__users') }}
),

addresses AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__addresses') }}
),

orders_aggregated_by_user AS (
    SELECT
        *
    FROM
        {{ ref('_int_orders_aggregated_by_user') }}
),

events_aggregated_by_user AS (
    SELECT
        *
    FROM
        {{ ref('_int_events_aggregated_by_user') }}
)

SELECT
    users.user_id,
    users.user_created_at_utc,
    users.user_updated_at_utc,
    users.user_address_id AS user_address_id,
    addresses.address AS user_address,
    addresses.zipcode AS user_zipcode,
    addresses.state AS user_state,
    addresses.country AS user_country,
    orders_aggregated_by_user.total_orders,
    orders_aggregated_by_user.single_order_flag,
    orders_aggregated_by_user.multiple_orders_flag,
    orders_aggregated_by_user.orders_last_30_days,
    orders_aggregated_by_user.orders_last_90_days,
    orders_aggregated_by_user.orders_last_365_days,
    orders_aggregated_by_user.total_order_cost,
    orders_aggregated_by_user.average_order_cost,
    orders_aggregated_by_user.total_shipping_cost,
    orders_aggregated_by_user.average_shipping_cost,
    orders_aggregated_by_user.total_cost,
    orders_aggregated_by_user.average_cost,
    orders_aggregated_by_user.total_promos,
    orders_aggregated_by_user.promo_use_rate,
    orders_aggregated_by_user.first_order_date_utc,
    orders_aggregated_by_user.last_order_date_utc,
    events_aggregated_by_user.total_page_views,
    events_aggregated_by_user.unique_page_views,
    events_aggregated_by_user.total_add_to_carts,
    events_aggregated_by_user.total_checkouts
FROM users
LEFT JOIN addresses
    ON users.user_address_id = addresses.address_id
LEFT JOIN orders_aggregated_by_user
    ON users.user_id = orders_aggregated_by_user.user_id
LEFT JOIN events_aggregated_by_user
    ON users.user_id = events_aggregated_by_user.user_id