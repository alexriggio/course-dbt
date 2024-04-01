## Analytics Engineering with dbt
### Week 2 Assignment
##### Part 1: Models

**1. What is our user repeat rate?**
Repeat Rate = Users who purchased 2 or more times / users who purchased

Query: 
```
WITH order_counts AS (
SELECT 
    user_id,
    COUNT(*) AS n_orders
FROM _stg_postgres__orders
GROUP BY user_id
)

SELECT
    SUM(CASE WHEN n_orders > 1 THEN 1 END) /
    COUNT(*) AS repeat_rate
FROM order_counts;
```
Answer: 0.798387

**2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?**
Answer: 
**Likely to purchase:** High average order value, high order frequency, recent order, low discount code use, high engagement with website, short shipping duration, high average items per order
**Likely NOT to purchase:** Low average order value, low order frequency, high discount code use, low engagement with website, long shipping duration
**Features that I wish we had:** product returns, customer service interactions, product reviews, detailed website browsing behavior

**3. Explain the product mart models you added. Why did you organize the models in the way you did?**
Answer: 

**Core:** Added all the staging models to the core directory so that BI stakeholders can access these models as they see fit.

**Marketing:** Added a model that included order details at the user-level, including some demographic data and website event data so that the marketing department can drill down into different customer profiles, segment, and investigate factors that are motivating customers to place orders.

Product: Added models at the product level that included information on orders and page views so that relevant stakeholders can investigate what products are selling and how this ties into website behavior.

##### Part 2: Tests

**4. What assumptions are you making about each model? (i.e. why are you adding each test?)**
Answer: I am mainly making sure the primary keys are unique, there are no null values for most columns, there are only positive values for columns like 'price', and that certain date columns have an earlier date than other date columns that should naturally follow.

**5. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?**
Answer: All the tests I ran came back clean. 

##### Part 3: Snapshots

**6. Which products had their inventory change from week 1 to week 2? **
Query: 
```
WITH week1 AS (
SELECT 
    * 
FROM dev_db.dbt_alexmriggiogmailcom.products_snapshot
WHERE dbt_valid_from = '2024-03-24 20:54:53.053'
),

week2 AS(
SELECT
    *
FROM dev_db.dbt_alexmriggiogmailcom.products_snapshot
WHERE dbt_valid_from = '2024-04-01 02:27:46.032'
)

SELECT
    week1.product_id,
    week1.name,
    week1.price,
    week1.inventory AS inventory_1,
    week2.inventory AS inventory_2
FROM week1
LEFT JOIN week2
    ON week1.product_id = week2.product_id
WHERE week2.inventory IS NOT NULL
    AND week1.inventory != week2.inventory
```
| Name | INVENTORY_1 | INVENTORY_2 |
| ------ | ------ | ------ |
| Philodendron | 51 | 25 |
| Monstera | 77 | 64 |
| Pothos | 40 | 20 |
| String of pearls | 58 | 10 |

_______________________________________________
_______________________________________________

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
