/*
03_approved_vs_declined.sql
Purpose: compare approved and declined applicants at the application-record grain.
*/

SELECT
    CASE loan_approved
        WHEN 1 THEN 'Approved'
        WHEN 0 THEN 'Declined'
        ELSE 'Unknown'
    END AS decision,
    COUNT(*) AS applications,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(total_assets), 2) AS avg_total_assets,
    ROUND(AVG(total_liabilities), 2) AS avg_total_liabilities,
    ROUND(AVG(net_worth), 2) AS avg_net_worth,
    ROUND(AVG(debt_to_income_ratio), 4) AS avg_dti,
    ROUND(AVG(total_debt_to_income_ratio), 4) AS avg_total_dti,
    ROUND(AVG(credit_card_utilization_rate), 4) AS avg_card_utilization,
    ROUND(AVG(job_tenure_years), 2) AS avg_job_tenure_years,
    ROUND(AVG(dependents), 2) AS avg_dependents
FROM loan_applications
GROUP BY loan_approved
ORDER BY loan_approved DESC;

-- Approval rate gap for selected characteristics.
WITH profile AS (
    SELECT
        ROUND(AVG(CASE WHEN loan_approved = 1 THEN annual_income END), 2) AS approved_income,
        ROUND(AVG(CASE WHEN loan_approved = 0 THEN annual_income END), 2) AS declined_income,
        ROUND(AVG(CASE WHEN loan_approved = 1 THEN credit_score END), 2) AS approved_credit_score,
        ROUND(AVG(CASE WHEN loan_approved = 0 THEN credit_score END), 2) AS declined_credit_score,
        ROUND(AVG(CASE WHEN loan_approved = 1 THEN loan_amount END), 2) AS approved_loan_amount,
        ROUND(AVG(CASE WHEN loan_approved = 0 THEN loan_amount END), 2) AS declined_loan_amount,
        ROUND(AVG(CASE WHEN loan_approved = 1 THEN total_assets END), 2) AS approved_assets,
        ROUND(AVG(CASE WHEN loan_approved = 0 THEN total_assets END), 2) AS declined_assets,
        ROUND(AVG(CASE WHEN loan_approved = 1 THEN net_worth END), 2) AS approved_net_worth,
        ROUND(AVG(CASE WHEN loan_approved = 0 THEN net_worth END), 2) AS declined_net_worth
    FROM loan_applications
)
SELECT
    'Annual income' AS metric,
    approved_income AS approved,
    declined_income AS declined,
    ROUND(approved_income - declined_income, 2) AS absolute_gap,
    ROUND(100.0 * (approved_income / NULLIF(declined_income, 0) - 1), 1) AS approved_vs_declined_pct
FROM profile
UNION ALL
SELECT 'Credit score', approved_credit_score, declined_credit_score,
       ROUND(approved_credit_score - declined_credit_score, 2),
       ROUND(100.0 * (approved_credit_score / NULLIF(declined_credit_score, 0) - 1), 1)
FROM profile
UNION ALL
SELECT 'Loan amount', approved_loan_amount, declined_loan_amount,
       ROUND(approved_loan_amount - declined_loan_amount, 2),
       ROUND(100.0 * (approved_loan_amount / NULLIF(declined_loan_amount, 0) - 1), 1)
FROM profile
UNION ALL
SELECT 'Total assets', approved_assets, declined_assets,
       ROUND(approved_assets - declined_assets, 2),
       ROUND(100.0 * (approved_assets / NULLIF(declined_assets, 0) - 1), 1)
FROM profile
UNION ALL
SELECT 'Net worth', approved_net_worth, declined_net_worth,
       ROUND(approved_net_worth - declined_net_worth, 2),
       ROUND(100.0 * (approved_net_worth / NULLIF(declined_net_worth, 0) - 1), 1)
FROM profile;
