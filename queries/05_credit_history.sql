/*
05_credit_history.sql
Purpose: assess approval differences by prior adverse credit history.
*/

SELECT
    CASE bankruptcy_history
        WHEN 0 THEN 'No bankruptcy history'
        WHEN 1 THEN 'Prior bankruptcy'
        ELSE 'Unknown'
    END AS bankruptcy_group,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY bankruptcy_history
ORDER BY bankruptcy_history;

SELECT
    CASE previous_loan_defaults
        WHEN 0 THEN 'No previous loan defaults'
        WHEN 1 THEN 'Previous loan defaults'
        ELSE 'Unknown'
    END AS previous_default_group,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY previous_loan_defaults
ORDER BY previous_loan_defaults;

SELECT
    CASE
        WHEN payment_history < 10 THEN '<10'
        WHEN payment_history < 20 THEN '10–19'
        WHEN payment_history < 30 THEN '20–29'
        ELSE '30+'
    END AS payment_history_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY payment_history_band
ORDER BY payment_history_band;

SELECT
    CASE
        WHEN credit_history_years < 5 THEN '<5 years'
        WHEN credit_history_years < 10 THEN '5–9 years'
        WHEN credit_history_years < 20 THEN '10–19 years'
        ELSE '20+ years'
    END AS credit_history_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY credit_history_band
ORDER BY credit_history_band;
