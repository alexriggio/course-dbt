WITH users_source AS (
    SELECT
        *
    FROM
        {{ source('postgres', 'users') }}
)

SELECT 
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at AS user_created_at_utc,
    updated_at AS user_updated_at_utc,
    address_id AS user_address_id
FROM users_source