{{ config(materialized='table')}}

WITH events AS (
    SELECT
        *
    FROM
        {{ ref('_stg_postgres__events')}}
)

SELECT
product_id,
event_id,
session_id,
event_created_at_utc AS page_view_created_at_utc
FROM events
WHERE event_type = 'page_view'