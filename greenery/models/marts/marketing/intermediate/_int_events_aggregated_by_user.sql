{{ config(materialized='view') }}

WITH events AS (
    SELECT 
        *
    FROM
        {{ ref('_stg_postgres__events') }}
)

SELECT
    user_id,
    SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS total_page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN page_url END) AS unique_page_views,
    SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS total_add_to_carts,
    SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS total_checkouts,
    COUNT(DISTINCT(session_id)) AS total_sessions
FROM events
GROUP BY user_id