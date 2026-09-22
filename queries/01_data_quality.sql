/*
01_data_quality.sql
Purpose: establish the population before analytical interpretation.
*/

-- 1. Overall row count
SELECT COUNT(*) AS total_application_rows
FROM loan_applications;

-- 2. Approval population reconciliation
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) AS approved_rows,
    SUM(CASE WHEN loan_approved = 0 THEN 1 ELSE 0 END) AS declined_rows,
    SUM(CASE WHEN loan_approved IN (0, 1) THEN 1 ELSE 0 END) AS valid_target_rows
FROM loan_applications;

-- 3. Unexpected target values
SELECT
    loan_approved,
    COUNT(*) AS rows
FROM loan_applications
GROUP BY loan_approved
ORDER BY loan_approved;

-- 4. Missing key fields
SELECT
    SUM(CASE WHEN application_date IS NULL THEN 1 ELSE 0 END) AS missing_application_date,
    SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS missing_annual_income,
    SUM(CASE WHEN credit_score IS NULL THEN 1 ELSE 0 END) AS missing_credit_score,
    SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS missing_loan_amount,
    SUM(CASE WHEN loan_approved IS NULL THEN 1 ELSE 0 END) AS missing_approval,
    SUM(CASE WHEN risk_score IS NULL THEN 1 ELSE 0 END) AS missing_risk_score
FROM loan_applications;

-- 5. Exact duplicate records across the analytics grain.
-- The source contains no explicit application ID, so exact duplicates are a data-quality flag,
-- not automatically evidence that a record should be removed.
SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT
        application_date, age, annual_income, credit_score, employment_status,
        education_level, experience_years, loan_amount, loan_duration_months,
        marital_status, dependents, home_ownership_status, monthly_debt_payments,
        credit_card_utilization_rate, open_credit_lines, credit_inquiries,
        debt_to_income_ratio, bankruptcy_history, loan_purpose,
        previous_loan_defaults, payment_history, credit_history_years,
        savings_balance, checking_balance, total_assets, total_liabilities,
        monthly_income, utility_payment_history, job_tenure_years, net_worth,
        base_interest_rate, interest_rate, monthly_loan_payment,
        total_debt_to_income_ratio, loan_approved, risk_score,
        COUNT(*) AS record_count
    FROM loan_applications
    GROUP BY
        application_date, age, annual_income, credit_score, employment_status,
        education_level, experience_years, loan_amount, loan_duration_months,
        marital_status, dependents, home_ownership_status, monthly_debt_payments,
        credit_card_utilization_rate, open_credit_lines, credit_inquiries,
        debt_to_income_ratio, bankruptcy_history, loan_purpose,
        previous_loan_defaults, payment_history, credit_history_years,
        savings_balance, checking_balance, total_assets, total_liabilities,
        monthly_income, utility_payment_history, job_tenure_years, net_worth,
        base_interest_rate, interest_rate, monthly_loan_payment,
        total_debt_to_income_ratio, loan_approved, risk_score
    HAVING COUNT(*) > 1
);

-- 6. Numeric sanity checks
SELECT
    SUM(CASE WHEN annual_income <= 0 THEN 1 ELSE 0 END) AS non_positive_income,
    SUM(CASE WHEN loan_amount <= 0 THEN 1 ELSE 0 END) AS non_positive_loan_amount,
    SUM(CASE WHEN credit_score < 300 OR credit_score > 850 THEN 1 ELSE 0 END) AS out_of_range_credit_score,
    SUM(CASE WHEN age < 18 OR age > 100 THEN 1 ELSE 0 END) AS unusual_age,
    SUM(CASE WHEN dependents < 0 THEN 1 ELSE 0 END) AS negative_dependents
FROM loan_applications;
