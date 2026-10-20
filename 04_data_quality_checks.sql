-- Enterprise Data Warehouse | Data Quality Checks
-- Each query should return zero rows when the data is valid.

-- 1. Duplicate transaction business identifiers
SELECT transaction_id, COUNT(*) AS duplicate_count
FROM fact_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 2. Invalid or missing transaction amounts
SELECT transaction_id, amount
FROM fact_transactions
WHERE amount IS NULL OR amount <= 0;

-- 3. Invalid transaction statuses
SELECT transaction_id, transaction_status
FROM fact_transactions
WHERE transaction_status IS NULL
   OR transaction_status NOT IN ('COMPLETED', 'FAILED', 'PENDING');

-- 4. Missing customer dimension references
SELECT f.transaction_id
FROM fact_transactions f
LEFT JOIN dim_customer c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- 5. Missing account dimension references
SELECT f.transaction_id
FROM fact_transactions f
LEFT JOIN dim_account a ON f.account_key = a.account_key
WHERE a.account_key IS NULL;

-- 6. Missing date dimension references
SELECT f.transaction_id
FROM fact_transactions f
LEFT JOIN dim_date d ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

-- 7. Invalid currency codes
SELECT account_id, currency_code
FROM dim_account
WHERE currency_code IS NULL
   OR currency_code NOT IN ('ARS', 'USD');

-- 8. Date dimension consistency
SELECT date_key, full_date
FROM dim_date
WHERE date_key <> CAST(TO_CHAR(full_date, 'YYYYMMDD') AS INTEGER)
   OR year_number <> EXTRACT(YEAR FROM full_date)
   OR quarter_number <> EXTRACT(QUARTER FROM full_date)
   OR month_number <> EXTRACT(MONTH FROM full_date)
   OR day_number <> EXTRACT(DAY FROM full_date);
