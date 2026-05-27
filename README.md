# AdvBDAssignment1

# Banking Fraud Monitoring System

## Project Overview

I created PostgreSQL database system for monitoring banking fraud activity.
The system stores customers, accounts, cards, transactions, fraud alerts and audit logs.
The main goal of project is to simulate how banking backend system can automatically detect suspicious transactions and generate fraud alerts.

## Setup Instructions

I executed all SQL scripts in PostgreSQL using DataGrip. I ran files in this order:
1. tables.sql
2. sample_data.sql
3. functions.sql
4. procedures.sql
5. triggers.sql
6. views.sql
7. materialized_views.sql
8. refresh.sql
9. demo_queries.sql (additional for demonstration)


## Assumptions

While making this system i made several assumptions:
- one customer can have multiple accounts and so as one account can have multiple cards
- high transaction amounts are more risky
- foreign transactions are more suspicious
- some merchant categories have higher fraud risk
- risk score ranges from 0 to 100
- transactions with risk score greater than or equal to 70 become FLAGGED


## Explanation of Fraud Logic

I calculate transaction risk score using several fraud detection rules. Risk score increases when:
1)  transaction amount is greater than or equal to 10000
2)  transaction country differs from customer country
3)  merchant category is risky

Risky categories are transactions with info like CRYPTO, GAMBLING, JEWELRY, TRANSFER

When transaction risk score becomes high than transaction status changes to FLAGGED. And system automatically creates fraud alert.
I implemented this with functions, procedures and triggers.


## Refresh Strategy for Materialized Views

I created materialized view mv_daily_fraud_summary

It stores daily fraud statistics and analytical data. Materialized views don't refresh automatically, so i created procedure:
CALL refresh_fraud_dashboard();
It refreshes  materialized view and updates fraud analytics after inserting new transactions.


## Demo Queries

I added demo analytical queries in demo_queries.sql
They demonstrate: fraud detection, fraud alerts, customer risk profiles, flagged transactions, fraud analytics dashboard and transaction statistics.
