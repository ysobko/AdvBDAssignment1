DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS fraud_alerts CASCADE;
DROP TABLE IF EXISTS fraud_rules CASCADE;
DROP TABLE IF EXISTS transaction_status_history CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS cards CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    country_code CHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE accounts (
    account_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    account_number VARCHAR(30) NOT NULL UNIQUE,
    currency VARCHAR(3) NOT NULL,
    balance NUMERIC(12, 2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CHECK (currency IN ('UAH', 'USD', 'EUR')),
    CHECK (balance >= 0),
    CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED'))
);

CREATE TABLE cards (
    card_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL,
    card_number_hash VARCHAR(255) NOT NULL UNIQUE,
    card_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    expiration_date DATE NOT NULL,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id),

    CHECK (card_type IN ('DEBIT', 'CREDIT')),
    CHECK (status IN ('ACTIVE', 'BLOCKED', 'EXPIRED'))
);

CREATE TABLE transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL,
    card_id BIGINT,
    amount NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    merchant_category VARCHAR(50) NOT NULL,
    merchant_country CHAR(2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    risk_score INT DEFAULT 0,
    transaction_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (card_id) REFERENCES cards(card_id),

    CHECK (amount > 0),
    CHECK (currency IN ('UAH', 'USD', 'EUR')),
    CHECK (status IN ('PENDING', 'APPROVED', 'DECLINED', 'FLAGGED')),
    CHECK (risk_score BETWEEN 0 AND 100)
);

CREATE TABLE transaction_status_history (
    history_id BIGSERIAL PRIMARY KEY,
    transaction_id BIGINT NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(50) DEFAULT CURRENT_USER,

    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

CREATE TABLE fraud_rules (
    rule_id BIGSERIAL PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL UNIQUE,
    rule_type VARCHAR(50) NOT NULL,
    threshold_value INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,

    CHECK (threshold_value >= 0)
);

CREATE TABLE fraud_alerts (
    alert_id BIGSERIAL PRIMARY KEY,
    transaction_id BIGINT NOT NULL,
    rule_id BIGINT,
    reason TEXT NOT NULL,
    risk_score INT NOT NULL,
    alert_status VARCHAR(20) DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (rule_id) REFERENCES fraud_rules(rule_id),

    CHECK (risk_score BETWEEN 0 AND 100),
    CHECK (alert_status IN ('OPEN', 'REVIEWING', 'RESOLVED', 'FALSE_POSITIVE'))
);

CREATE TABLE audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);
