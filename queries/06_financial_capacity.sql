/*
06_financial_capacity.sql
Purpose: test financial-capacity characteristics and identify variables that do/don't separate groups.
*/

WITH bands AS (
    SELECT
        CASE
            WHEN total_assets < 25000 THEN '<$25K'
            WHEN total_assets < 75000 THEN '$25–75K'
            WHEN total_assets < 150000 THEN '$75–150K'
            WHEN total_assets < 300000 THEN '$150–300K'
            ELSE '$300K+'
        END AS asset_band,
        loan_approved
    FROM loan_applications
)
SELECT
    asset_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM bands
GROUP BY asset_band
ORDER BY CASE asset_band
    WHEN '<$25K' THEN 1
    WHEN '$25–75K' THEN 2
    WHEN '$75–150K' THEN 3
    WHEN '$150–300K' THEN 4
    WHEN '$300K+' THEN 5
END;

WITH bands AS (
    SELECT
        CASE
            WHEN net_worth < 25000 THEN '<$25K'
            WHEN net_worth < 75000 THEN '$25–75K'
            WHEN net_worth < 150000 THEN '$75–150K'
            WHEN net_worth < 300000 THEN '$150–300K'
            ELSE '$300K+'
        END AS net_worth_band,
        loan_approved
    FROM loan_applications
)
SELECT
    net_worth_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM bands
GROUP BY net_worth_band
ORDER BY CASE net_worth_band
    WHEN '<$25K' THEN 1
    WHEN '$25–75K' THEN 2
    WHEN '$75–150K' THEN 3
    WHEN '$150–300K' THEN 4
    WHEN '$300K+' THEN 5
END;

WITH bands AS (
    SELECT
        CASE
            WHEN debt_to_income_ratio < 0.20 THEN '<20%'
            WHEN debt_to_income_ratio < 0.30 THEN '20–30%'
            WHEN debt_to_income_ratio < 0.40 THEN '30–40%'
            WHEN debt_to_income_ratio < 0.50 THEN '40–50%'
            ELSE '50%+'
        END AS dti_band,
        loan_approved
    FROM loan_applications
)
SELECT
    dti_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM bands
GROUP BY dti_band
ORDER BY CASE dti_band
    WHEN '<20%' THEN 1
    WHEN '20–30%' THEN 2
    WHEN '30–40%' THEN 3
    WHEN '40–50%' THEN 4
    WHEN '50%+' THEN 5
END;

-- Liquidity profile
SELECT
    CASE
        WHEN liquid_assets < 5000 THEN '<$5K'
        WHEN liquid_assets < 15000 THEN '$5–15K'
        WHEN liquid_assets < 30000 THEN '$15–30K'
        ELSE '$30K+'
    END AS liquid_asset_band,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY liquid_asset_band
ORDER BY liquid_asset_band;
