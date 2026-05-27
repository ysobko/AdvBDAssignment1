CREATE OR REPLACE VIEW vw_customer_accounts AS
SELECT c.customer_id, c.first_name, c.last_name, a.account_number, a.currency, a.balance, a.status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

CREATE OR REPLACE VIEW vw_recent_transactions AS
SELECT transaction_id, amount, currency, merchant_category, merchant_country, status, risk_score, transaction_at
FROM transactions
ORDER BY transaction_at DESC;

CREATE OR REPLACE VIEW vw_flagged_transactions AS
SELECT transaction_id, amount, currency, merchant_category, merchant_country, risk_score
FROM transactions WHERE status = 'FLAGGED';

CREATE OR REPLACE VIEW vw_customer_risk_profile AS
SELECT c.customer_id, c.first_name, c.last_name,
    COUNT(t.transaction_id) AS total_transactions,
    AVG(t.risk_score) AS average_risk_score,
    SUM(t.amount) AS total_transaction_amount
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name;


SELECT * FROM vw_customer_accounts;

SELECT * FROM vw_recent_transactions;

SELECT * FROM vw_flagged_transactions;

SELECT * FROM vw_customer_risk_profile;
