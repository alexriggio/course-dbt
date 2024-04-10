{{ 
    config(
        materialized='table',
        post_hook=[
            "{{ grant('reporting') }}"
        ]  
    )  
}}

WITH events AS (
    SELECT
        *
        , MIN(event_created_at_utc) OVER(PARTITION BY session_id) AS session_start
        , MAX(event_created_at_utc) OVER(PARTITION BY session_id) AS session_end
    FROM
        {{ ref('_stg_postgres__events') }}
),

page_and_cart_activity AS (
SELECT
    product_id
    , session_id
    , MIN(session_start) AS session_start
    , MAX(session_end) AS session_end
    , {{ dbt_utils.pivot(
            column='event_type',
            values=['page_view', 'add_to_cart'],
            quote_identifiers=false
    ) }}
FROM events
GROUP BY product_id, session_id
HAVING product_id IS NOT NULL
),

checkout_and_shipped_activity AS (
SELECT
    session_id
    , {{ dbt_utils.pivot(
            column='event_type',
            values=['checkout', 'package_shipped'],
            quote_identifiers=false
    ) }}
FROM events
GROUP BY product_id, session_id
HAVING product_id IS NULL
)

SELECT
    pa.product_id
    , pa.session_id
    , pa.session_start
    , pa.session_end
    , DATEDIFF(minute, pa.session_start, pa.session_end) AS session_length_minutes
    , pa.page_view
    , pa.add_to_cart
    , {{ conditional_checkout_value(
            condition_column='pa.add_to_cart', 
            condition_threshold=0, 
            value_if_met=0,
            value_column_if_not_met='co.checkout'
        ) }} AS checkout
    , {{ conditional_checkout_value(
            condition_column='pa.add_to_cart', 
            condition_threshold=0, 
            value_if_met=0,
            value_column_if_not_met='co.package_shipped'
        ) }} AS package_shipped
FROM
    page_and_cart_activity pa
LEFT JOIN
    checkout_and_shipped_activity co ON pa.session_id = co.session_id

