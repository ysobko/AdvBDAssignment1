CREATE OR REPLACE FUNCTION save_transaction_history()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO transaction_status_history ( transaction_id, old_status, new_status )
    VALUES ( NEW.transaction_id,OLD.status,NEW.status
    );
    RETURN NEW;

END;
$$;


CREATE TRIGGER trg_save_transaction_history
AFTER UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION save_transaction_history();


CREATE OR REPLACE FUNCTION update_account_balance()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF NEW.status = 'APPROVED' THEN
        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;
    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_update_account_balance
AFTER UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_account_balance();


CREATE OR REPLACE FUNCTION check_transaction_risk()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    calculated_score INT;
BEGIN
    calculated_score := calculate_transaction_risk_score(NEW.transaction_id);
    UPDATE transactions
    SET risk_score = calculated_score
    WHERE transaction_id = NEW.transaction_id;

    IF calculated_score >= 70 THEN
        UPDATE transactions
        SET status = 'FLAGGED'
        WHERE transaction_id = NEW.transaction_id;

        INSERT INTO fraud_alerts (transaction_id, reason, risk_score,alert_status )
        VALUES ( NEW.transaction_id,'High risk transaction',calculated_score,'OPEN' );
    END IF;
    
    RETURN NEW;

END;
$$;


CREATE TRIGGER trg_check_transaction_risk
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION check_transaction_risk();


CREATE OR REPLACE FUNCTION save_customer_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO audit_log (customer_id, table_name, operation, old_value, new_value)
    VALUES ( NEW.customer_id,'customers',TG_OP,OLD.first_name,NEW.first_name);

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_save_customer_audit
AFTER UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION save_customer_audit();


CREATE OR REPLACE FUNCTION prevent_customer_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    account_count INT;
BEGIN
    SELECT COUNT(*)
    INTO account_count
    FROM accounts
    WHERE customer_id = OLD.customer_id;

    IF account_count > 0 THEN
        RAISE EXCEPTION 'Cannot delete customer with accounts';
    END IF;

    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION prevent_customer_delete();

INSERT INTO transactions ( account_id, card_id, amount, currency, merchant_category, merchant_country, status)
VALUES (1,1,50000,'UAH','CRYPTO','US', 'PENDING'
);

SELECT transaction_id, amount, status, risk_score
FROM transactions
ORDER BY transaction_id DESC
LIMIT 1;
