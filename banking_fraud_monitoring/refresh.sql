CREATE OR REPLACE PROCEDURE refresh_fraud_dashboard()
LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_daily_fraud_summary;
END;
$$;


CALL refresh_fraud_dashboard();

SELECT * FROM mv_daily_fraud_summary;


INSERT INTO transactions (account_id, card_id, amount, currency, merchant_category, merchant_country, status
)
VALUES (1,1,90000,'UAH','CRYPTO','US','PENDING'
);
