CREATE OR REPLACE FUNCTION calculate_customer_daily_volume(
    p_customer_id BIGINT,
    p_target_date DATE
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_amount NUMERIC;
BEGIN
    SELECT COALESCE(SUM(t.amount), 0)
    INTO total_amount
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE a.customer_id = p_customer_id
      AND DATE(t.transaction_at) = p_target_date;
    RETURN total_amount;
END;
$$;

CREATE OR REPLACE FUNCTION is_foreign_transaction(
    p_customer_id BIGINT,
    p_merchant_country CHAR(2)
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    customer_country CHAR(2);
BEGIN
    SELECT country_code
    INTO customer_country
    FROM customers
    WHERE customer_id = p_customer_id;

    IF customer_country <> p_merchant_country THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;


CREATE OR REPLACE FUNCTION get_customer_age(
    p_customer_id BIGINT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    customer_age INT;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(birth_date))
    INTO customer_age
    FROM customers
    WHERE customer_id = p_customer_id;
    RETURN customer_age;
END;
$$;


CREATE OR REPLACE FUNCTION mask_card_number(
    p_card_number TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN '**** **** **** ' || RIGHT(p_card_number, 4);
END;
$$;


CREATE OR REPLACE FUNCTION calculate_transaction_risk_score(
    p_transaction_id BIGINT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    result_score INT DEFAULT 0;
    transaction_amount NUMERIC;
    transaction_country CHAR(2);
    transaction_category VARCHAR(50);
    transaction_customer_id BIGINT;
BEGIN
    SELECT t.amount, t.merchant_country, t.merchant_category, a.customer_id
    INTO transaction_amount, transaction_country, transaction_category, transaction_customer_id
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE t.transaction_id = p_transaction_id;

    IF transaction_amount >= 10000 THEN
        result_score := result_score + 40;
    END IF;
    IF is_foreign_transaction(transaction_customer_id, transaction_country) THEN
        result_score := result_score + 30;
    END IF;
    IF transaction_category IN ('CRYPTO', 'GAMBLING', 'JEWELRY', 'TRANSFER') THEN
        result_score := result_score + 30;
    END IF;
    IF result_score > 100 THEN
        result_score := 100;
    END IF;
    RETURN result_score;
END;
$$;


SELECT calculate_customer_daily_volume(1, '2026-05-20');

SELECT is_foreign_transaction(1, 'US');

SELECT get_customer_age(1);

SELECT mask_card_number('1234567812345678');

SELECT calculate_transaction_risk_score(15);

