-- Enterprise Data Warehouse | Advanced SQL Analytics
-- PostgreSQL | Synthetic banking data

-- 1. Completed transaction totals by customer and currency
SELECT
    c.customer_id,
    c.customer_name,
    a.currency_code,
    COUNT(*) AS transaction_count,
    SUM(f.amount) AS total_amount
FROM fact_transactions f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_account a ON f.account_key = a.account_key
WHERE f.transaction_status = 'COMPLETED'
GROUP BY c.customer_id, c.customer_name, a.currency_code
ORDER BY a.currency_code, total_amount DESC;

-- 2. Monthly transaction summary by currency and status
SELECT
    d.year_number,
    d.month_number,
    a.currency_code,
    f.transaction_status,
    COUNT(*) AS transaction_count,
    SUM(f.amount) AS total_amount
FROM fact_transactions f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_account a ON f.account_key = a.account_key
GROUP BY d.year_number, d.month_number,
         a.currency_code, f.transaction_status
ORDER BY d.year_number, d.month_number,
         a.currency_code, f.transaction_status;

-- 3. Rank customers by completed transaction volume per currency
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        a.currency_code,
        SUM(f.amount) AS total_amount
    FROM fact_transactions f
    JOIN dim_customer c ON f.customer_key = c.customer_key
    JOIN dim_account a ON f.account_key = a.account_key
    WHERE f.transaction_status = 'COMPLETED'
    GROUP BY c.customer_id, c.customer_name, a.currency_code
)
SELECT
    customer_id,
    customer_name,
    currency_code,
    total_amount,
    DENSE_RANK() OVER (
        PARTITION BY currency_code
        ORDER BY total_amount DESC
    ) AS customer_rank
FROM customer_totals
ORDER BY currency_code, customer_rank;

-- 4. Running completed transaction totals per customer and currency
SELECT
    c.customer_id,
    a.currency_code,
    d.full_date,
    f.transaction_id,
    f.amount,
    SUM(f.amount) OVER (
        PARTITION BY c.customer_id, a.currency_code
        ORDER BY d.full_date, f.transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM fact_transactions f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_account a ON f.account_key = a.account_key
JOIN dim_date d ON f.date_key = d.date_key
WHERE f.transaction_status = 'COMPLETED'
ORDER BY c.customer_id, a.currency_code,
         d.full_date, f.transaction_id;

-- 5. Transaction success rate by currency
SELECT
    a.currency_code,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE f.transaction_status = 'COMPLETED'
    ) AS completed_transactions,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE f.transaction_status = 'COMPLETED'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate_pct
FROM fact_transactions f
JOIN dim_account a ON f.account_key = a.account_key
GROUP BY a.currency_code
ORDER BY a.currency_code;
