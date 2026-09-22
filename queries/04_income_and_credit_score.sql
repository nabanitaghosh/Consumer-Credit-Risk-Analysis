/*
04_income_and_credit_score.sql
Purpose: produce chart-ready approval rates for major credit-capacity bands.
*/

WITH income_bands AS (
    SELECT
        CASE
            WHEN annual_income < 40000 THEN '<$40K'
            WHEN annual_income < 60000 THEN '$40–60K'
            WHEN annual_income < 80000 THEN '$60–80K'
            WHEN annual_income < 120000 THEN '$80–120K'
            WHEN annual_income < 160000 THEN '$120–160K'
            ELSE '$160K+'
        END AS income_band,
        loan_approved
    FROM loan_applications
)
SELECT
    income_band,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM income_bands
GROUP BY income_band
ORDER BY CASE income_band
    WHEN '<$40K' THEN 1
    WHEN '$40–60K' THEN 2
    WHEN '$60–80K' THEN 3
    WHEN '$80–120K' THEN 4
    WHEN '$120–160K' THEN 5
    WHEN '$160K+' THEN 6
END;

WITH credit_bands AS (
    SELECT
        CASE
            WHEN credit_score <= 550 THEN '≤550'
            WHEN credit_score <= 600 THEN '551–600'
            WHEN credit_score <= 650 THEN '601–650'
            WHEN credit_score <= 700 THEN '651–700'
            ELSE '701+'
        END AS credit_band,
        loan_approved
    FROM loan_applications
)
SELECT
    credit_band,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM credit_bands
GROUP BY credit_band
ORDER BY CASE credit_band
    WHEN '≤550' THEN 1
    WHEN '551–600' THEN 2
    WHEN '601–650' THEN 3
    WHEN '651–700' THEN 4
    WHEN '701+' THEN 5
END;

WITH ratio_bands AS (
    SELECT
        CASE
            WHEN loan_to_annual_income < 0.10 THEN '<10%'
            WHEN loan_to_annual_income < 0.20 THEN '10–20%'
            WHEN loan_to_annual_income < 0.30 THEN '20–30%'
            WHEN loan_to_annual_income < 0.40 THEN '30–40%'
            ELSE '40%+'
        END AS loan_to_income_band,
        loan_approved
    FROM loan_applications
)
SELECT
    loan_to_income_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM ratio_bands
GROUP BY loan_to_income_band
ORDER BY CASE loan_to_income_band
    WHEN '<10%' THEN 1
    WHEN '10–20%' THEN 2
    WHEN '20–30%' THEN 3
    WHEN '30–40%' THEN 4
    WHEN '40%+' THEN 5
END;
