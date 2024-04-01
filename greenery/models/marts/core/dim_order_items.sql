{{ config(materialized='table') }}

SELECT
    *
FROM
    {{ ref('_stg_postgres__order_items')}}