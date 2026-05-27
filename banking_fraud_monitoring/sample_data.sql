INSERT INTO customers ( first_name,last_name, email,birth_date, country_code)
VALUES
('Ivan', 'Petrenko', 'ivan.petrenko@gmail.com', '1998-05-12', 'UA'),
('Olena', 'Shevchenko', 'olena.shevchenko@gmail.com', '2001-09-20', 'UA'),
('John', 'Smith', 'john.smith@gmail.com', '1985-03-15', 'US'),
('Emma', 'Brown', 'emma.brown@gmail.com', '1992-11-08', 'GB'),
('Marie', 'Dubois', 'marie.dubois@gmail.com', '1996-12-03', 'FR'),
('Hans', 'Muller', 'hans.muller@gmail.com', '1988-06-18', 'DE'),
('Sofia', 'Rossi', 'sofia.rossi@gmail.com', '1994-04-27', 'IT'),
('Carlos', 'Garcia', 'carlos.garcia@gmail.com', '1990-08-14', 'ES');



INSERT INTO accounts (customer_id, account_number, currency, balance, status)
VALUES
(1, 'UA100001', 'UAH', 50000, 'ACTIVE'),
(2, 'UA100002', 'UAH', 32000, 'ACTIVE'),
(3, 'US100003', 'USD', 8500, 'ACTIVE'),
(4, 'GB100004', 'EUR', 9000, 'ACTIVE'),
(5, 'FR100005', 'EUR', 6500, 'ACTIVE'),
(6, 'DE100006', 'EUR', 12000, 'ACTIVE'),
(7, 'IT100007', 'EUR', 4000, 'ACTIVE'),
(8, 'ES100008', 'EUR', 7000, 'ACTIVE');



INSERT INTO cards (account_id, card_number_hash, card_type, status, expiration_date)
VALUES
(1, 'hash_card_1111', 'DEBIT', 'ACTIVE', '2028-12-31'),
(2, 'hash_card_2222', 'DEBIT', 'ACTIVE', '2027-10-31'),
(3, 'hash_card_3333', 'CREDIT', 'ACTIVE', '2029-05-31'),
(4, 'hash_card_4444', 'CREDIT', 'ACTIVE', '2028-03-31'),
(5, 'hash_card_5555', 'DEBIT', 'ACTIVE', '2029-08-31'),
(6, 'hash_card_6666', 'DEBIT', 'ACTIVE', '2027-06-30'),
(7, 'hash_card_7777', 'CREDIT', 'ACTIVE', '2028-09-30'),
(8, 'hash_card_8888', 'DEBIT', 'ACTIVE', '2029-11-30');



INSERT INTO fraud_rules (rule_name, rule_type, threshold_value,is_active
)
VALUES
('Large transaction amount', 'AMOUNT', 10000, TRUE),
('Multiple foreign transactions', 'COUNTRY', 3, TRUE),
('Very high risk score', 'RISK_SCORE', 80, TRUE);



INSERT INTO transactions (account_id, card_id, amount, currency, merchant_category, merchant_country,status,
    risk_score, transaction_at)
VALUES
(1, 1, 850, 'UAH', 'GROCERY', 'UA', 'APPROVED', 5, '2026-05-20 09:15:00'),
(1, 1, 1200, 'UAH', 'CAFE', 'UA', 'APPROVED', 8, '2026-05-20 14:20:00'),
(2, 2, 5400, 'UAH', 'ELECTRONICS', 'UA', 'PENDING', 25, '2026-05-21 11:40:00'),
(3, 3, 250, 'USD', 'BOOKS', 'US', 'APPROVED', 5, '2026-05-21 13:15:00'),
(4, 4, 1700, 'EUR', 'TRAVEL', 'GB', 'APPROVED', 12, '2026-05-22 10:30:00'),
(5, 5, 430, 'EUR', 'PHARMACY', 'FR', 'APPROVED', 5, '2026-05-22 15:10:00'),
(6, 6, 2200, 'EUR', 'FUEL', 'DE', 'APPROVED', 10, '2026-05-23 08:45:00'),
(7, 7, 980, 'EUR', 'RESTAURANT', 'IT', 'APPROVED', 7, '2026-05-23 19:20:00'),
(8, 8, 760, 'EUR', 'CLOTHES', 'ES', 'APPROVED', 9, '2026-05-24 16:00:00'),
(2, 2, 12500, 'UAH', 'ONLINE_SHOP', 'US', 'PENDING', 60, '2026-05-21 18:30:00'),
(3, 3, 9500, 'USD', 'LUXURY', 'GB', 'PENDING', 55, '2026-05-22 09:25:00'),
(4, 4, 14500, 'EUR', 'HOTEL', 'FR', 'PENDING', 65, '2026-05-22 21:10:00'),
(6, 6, 8700, 'EUR', 'JEWELRY', 'IT', 'PENDING', 58, '2026-05-23 13:40:00'),
(7, 7, 16000, 'EUR', 'ONLINE_SHOP', 'US', 'PENDING', 68, '2026-05-24 11:25:00'),
(1, 1, 45000, 'UAH', 'CRYPTO', 'US', 'FLAGGED', 92, '2026-05-24 23:10:00'),
(3, 3, 30000, 'USD', 'TRANSFER', 'GB', 'FLAGGED', 95, '2026-05-25 01:15:00'),
(5, 5, 52000, 'EUR', 'GAMBLING', 'ES', 'FLAGGED', 97, '2026-05-25 03:45:00'),
(8, 8, 27000, 'EUR', 'CRYPTO', 'DE', 'FLAGGED', 90, '2026-05-25 05:30:00'),
(2, 2, 70000, 'UAH', 'TRANSFER', 'US', 'DECLINED', 99, '2026-05-25 07:00:00'),
(4, 4, 35000, 'EUR', 'CRYPTO', 'GB', 'DECLINED', 96, '2026-05-25 08:20:00');


SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM cards;
SELECT COUNT(*) FROM fraud_rules;
SELECT COUNT(*) FROM transactions;

SELECT status, COUNT(*)
FROM transactions
GROUP BY status;
