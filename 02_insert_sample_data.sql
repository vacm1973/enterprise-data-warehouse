-- Synthetic sample data for Enterprise Data Warehouse

INSERT INTO dim_customer (customer_id, customer_name, customer_segment, region)
VALUES
(101, 'Customer Alpha', 'RETAIL', 'Buenos Aires'),
(102, 'Customer Beta', 'PREMIUM', 'Cordoba'),
(103, 'Customer Gamma', 'RETAIL', 'Rosario'),
(104, 'Customer Delta', 'CORPORATE', 'Mendoza');

INSERT INTO dim_account (account_id, account_type, currency_code)
VALUES
(1001, 'CHECKING', 'ARS'),
(1002, 'SAVINGS', 'ARS'),
(1003, 'CHECKING', 'USD'),
(1004, 'SAVINGS', 'USD');

INSERT INTO dim_date (date_key, full_date, year_number, quarter_number, month_number, day_number)
VALUES
(20260115, '2026-01-15', 2026, 1, 1, 15),
(20260116, '2026-01-16', 2026, 1, 1, 16),
(20260210, '2026-02-10', 2026, 1, 2, 10),
(20260211, '2026-02-11', 2026, 1, 2, 11);

INSERT INTO fact_transactions
(transaction_id, customer_key, account_key, date_key, transaction_type, transaction_status, amount)
SELECT v.transaction_id, c.customer_key, a.account_key, v.date_key,
       v.transaction_type, v.transaction_status, v.amount
FROM (VALUES
(1, 101, 1001, 20260115, 'TRANSFER', 'COMPLETED', 1500.00),
(2, 101, 1001, 20260116, 'PAYMENT', 'COMPLETED', 750.00),
(3, 102, 1002, 20260115, 'TRANSFER', 'COMPLETED', 3200.00),
(4, 102, 1002, 20260210, 'PAYMENT', 'FAILED', 900.00),
(5, 103, 1003, 20260210, 'TRANSFER', 'COMPLETED', 500.00),
(6, 103, 1003, 20260211, 'PAYMENT', 'PENDING', 300.00),
(7, 104, 1004, 20260211, 'TRANSFER', 'COMPLETED', 4200.00),
(8, 104, 1004, 20260116, 'PAYMENT', 'COMPLETED', 1100.00)
) AS v(transaction_id, customer_id, account_id, date_key,
       transaction_type, transaction_status, amount)
JOIN dim_customer c ON c.customer_id = v.customer_id
JOIN dim_account a ON a.account_id = v.account_id;
