WITH events_source AS (
    SELECT
    *
    FROM {{ source('postgres', 'events') }}
)

SELECT 
    event_id,
    session_id,
    user_id,
    event_type,
    page_url,
    created_at AS event_created_at_utc,
    order_id,
    product_id
FROM events_source