SELECT * FROM customers;

SELECT * FROM accounts;

SELECT * FROM transactions
ORDER BY transaction_at DESC;

SELECT transaction_id, amount, currency, status, risk_score
FROM transactions
WHERE status = 'APPROVED';

SELECT transaction_id, amount, merchant_category, merchant_country, risk_score
FROM transactions
WHERE status = 'FLAGGED';

SELECT transaction_id, amount, merchant_category, risk_score
FROM transactions
WHERE status = 'DECLINED';

SELECT * FROM fraud_alerts
ORDER BY created_at DESC;

SELECT * FROM transaction_status_history
ORDER BY changed_at DESC;

SELECT * FROM audit_log
ORDER BY changed_at DESC;

SELECT * FROM vw_customer_accounts;

SELECT *FROM vw_recent_transactions
LIMIT 10;

SELECT * FROM vw_flagged_transactions;

SELECT * FROM vw_customer_risk_profile
ORDER BY average_risk_score DESC;

SELECT * FROM mv_daily_fraud_summary
ORDER BY transaction_date;

SELECT status,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY status;

SELECT transaction_id, amount, merchant_category, risk_score
FROM transactions
ORDER BY risk_score DESC
LIMIT 10;

SELECT
    c.customer_id, c.first_name, c.last_name,
    SUM(t.amount) AS total_amount
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY
    c.customer_id,c.first_name,c.last_name
ORDER BY total_amount DESC;

SELECT
    AVG(amount) AS average_transaction_amount
FROM transactions;

SELECT transaction_id, amount, merchant_category, status
FROM transactions
WHERE amount > 10000
ORDER BY amount DESC;

CALL refresh_fraud_dashboard();

SELECT *
FROM mv_daily_fraud_summary
ORDER BY transaction_date;
