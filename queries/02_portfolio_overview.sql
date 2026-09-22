/*
02_portfolio_overview.sql
Purpose: establish baseline approval volume and portfolio profile.
*/

SELECT
    COUNT(*) AS applications,
    SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) AS approvals,
    SUM(CASE WHEN loan_approved = 0 THEN 1 ELSE 0 END) AS declines,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loan_applications;

SELECT
    loan_approved,
    COUNT(*) AS applications,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS population_share_pct,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(total_assets), 2) AS avg_total_assets,
    ROUND(AVG(net_worth), 2) AS avg_net_worth,
    ROUND(AVG(debt_to_income_ratio), 4) AS avg_dti,
    ROUND(AVG(credit_card_utilization_rate), 4) AS avg_card_utilization
FROM loan_applications
GROUP BY loan_approved
ORDER BY loan_approved;

SELECT
    strftime('%Y', application_date) AS application_year,
    COUNT(*) AS applications,
    SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY strftime('%Y', application_date)
ORDER BY application_year;
