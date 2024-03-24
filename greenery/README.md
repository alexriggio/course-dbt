## Analytics Engineering with dbt
### Part 4 of the Week 1 Assignment

**1. How many users do we have?**
Query: ```SELECT COUNT(user_id) FROM _stg_postgres__users```

Answer: 130

**2. On average, how many orders do we receive per hour?**
Query: ```SELECT
    COUNT(order_id) / ((MAX(created_at)::DATE - MIN(created_at)::DATE + 1) * 24) AS avg_orders_per_hour
FROM 
    _stg_postgres__orders```

Answer: 7.520833

**3. On average, how long does an order take from being placed to being delivered?**
Query: ```SELECT AVG(DATEDIFF('day', created_at, delivered_at)) AS avg_delivery_time_days
FROM _stg_postgres__orders
WHERE delivered_at IS NOT NULL```

Answer: 3.891803 days

**4. How many users have only made one purchase? Two purchases? Three+ purchases?**
Query: ```SELECT
  order_groups AS n_orders,
  COUNT(*) AS n_users
FROM (
  SELECT
    user_id,
    CASE 
      WHEN COUNT(order_id) >= 3 THEN '3+' 
      ELSE CAST(COUNT(order_id) AS VARCHAR) 
    END AS order_groups
  FROM 
    _stg_postgres__orders
  GROUP BY user_id
) AS order_counts
GROUP BY order_groups
ORDER BY order_groups```

Answer: 

| N_ORDERS | N_USERS |
| ------ | ------ |
| 1 | 25 |
| 2 | 28 |
| 3 | 71 |

**5. On average, how many unique sessions do we have per hour?**
Query: ```SELECT
COUNT(DISTINCT session_id) / COUNT(DISTINCT user_id)
FROM _stg_postgres__events```

Answer: 4.661290


### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
