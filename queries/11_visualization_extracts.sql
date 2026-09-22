/*
11_visualization_extracts.sql
Purpose: SQL-only, chart-ready result sets.
These queries can be pasted directly into a SQL result grid and exported as CSV
for a presentation layer if needed. No Python or Excel transformation is required.
*/

-- Visualization 1: approval rate by income band
WITH income_bands AS (
    SELECT
        CASE
            WHEN annual_income < 40000 THEN '<$40K'
            WHEN annual_income < 60000 THEN '$40–60K'
            WHEN annual_income < 80000 THEN '$60–80K'
            WHEN annual_income < 120000 THEN '$80–120K'
            WHEN annual_income < 160000 THEN '$120–160K'
            ELSE '$160K+'
        END AS band,
        loan_approved
    FROM loan_applications
)
SELECT
    band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM income_bands
GROUP BY band
ORDER BY CASE band
    WHEN '<$40K' THEN 1 WHEN '$40–60K' THEN 2 WHEN '$60–80K' THEN 3
    WHEN '$80–120K' THEN 4 WHEN '$120–160K' THEN 5 WHEN '$160K+' THEN 6 END;

-- Visualization 2: approval rate by credit score
WITH score_bands AS (
    SELECT
        CASE
            WHEN credit_score <= 550 THEN '≤550'
            WHEN credit_score <= 600 THEN '551–600'
            WHEN credit_score <= 650 THEN '601–650'
            WHEN credit_score <= 700 THEN '651–700'
            ELSE '701+'
        END AS band,
        loan_approved
    FROM loan_applications
)
SELECT
    band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM score_bands
GROUP BY band
ORDER BY CASE band
    WHEN '≤550' THEN 1 WHEN '551–600' THEN 2 WHEN '601–650' THEN 3
    WHEN '651–700' THEN 4 WHEN '701+' THEN 5 END;

-- Visualization 3: approved vs declined financial profile
SELECT
    CASE loan_approved WHEN 1 THEN 'Approved' ELSE 'Declined' END AS decision,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(total_assets), 2) AS avg_total_assets,
    ROUND(AVG(net_worth), 2) AS avg_net_worth
FROM loan_applications
GROUP BY loan_approved
ORDER BY loan_approved;

-- Visualization 4: adverse credit history
SELECT
    'Bankruptcy history' AS dimension,
    CASE bankruptcy_history WHEN 1 THEN 'Prior bankruptcy' ELSE 'No bankruptcy history' END AS segment,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY bankruptcy_history
UNION ALL
SELECT
    'Previous loan defaults' AS dimension,
    CASE previous_loan_defaults WHEN 1 THEN 'Previous loan defaults' ELSE 'No previous loan defaults' END AS segment,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY previous_loan_defaults;

-- Visualization 5: risk score
WITH risk_bands AS (
    SELECT
        CASE
            WHEN risk_score <= 40 THEN '≤40'
            WHEN risk_score <= 45 THEN '41–45'
            WHEN risk_score <= 50 THEN '46–50'
            WHEN risk_score <= 55 THEN '51–55'
            WHEN risk_score <= 60 THEN '56–60'
            ELSE '61+'
        END AS band,
        loan_approved
    FROM loan_applications
)
SELECT
    band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM risk_bands
GROUP BY band
ORDER BY CASE band
    WHEN '≤40' THEN 1 WHEN '41–45' THEN 2 WHEN '46–50' THEN 3
    WHEN '51–55' THEN 4 WHEN '56–60' THEN 5 WHEN '61+' THEN 6 END;
