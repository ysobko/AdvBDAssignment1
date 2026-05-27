CREATE MATERIALIZED VIEW mv_daily_fraud_summary AS
SELECT
    DATE(t.transaction_at) AS transaction_date,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_transaction_amount,
    COUNT(CASE WHEN t.status = 'FLAGGED' THEN 1 END) AS flagged_transactions,
    SUM(CASE WHEN t.status = 'FLAGGED' THEN t.amount ELSE 0 END) AS suspicious_transaction_amount,
    AVG(t.risk_score) AS average_risk_score,
    COUNT(fa.alert_id) AS total_fraud_alerts
FROM transactions t
LEFT JOIN fraud_alerts fa ON t.transaction_id = fa.transaction_id
GROUP BY DATE(t.transaction_at);

SELECT * FROM mv_daily_fraud_summary
ORDER BY transaction_date;


