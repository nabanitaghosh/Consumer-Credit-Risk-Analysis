/*
08_risk_score_review.sql
Purpose: understand how the supplied RiskScore aligns with observed approvals.
IMPORTANT: do not interpret this as an independent underwriting driver without
confirming how RiskScore was constructed and whether it was available before the decision.
*/

WITH risk_bands AS (
    SELECT
        CASE
            WHEN risk_score <= 40 THEN '≤40'
            WHEN risk_score <= 45 THEN '41–45'
            WHEN risk_score <= 50 THEN '46–50'
            WHEN risk_score <= 55 THEN '51–55'
            WHEN risk_score <= 60 THEN '56–60'
            ELSE '61+'
        END AS risk_score_band,
        loan_approved
    FROM loan_applications
)
SELECT
    risk_score_band,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM risk_bands
GROUP BY risk_score_band
ORDER BY CASE risk_score_band
    WHEN '≤40' THEN 1
    WHEN '41–45' THEN 2
    WHEN '46–50' THEN 3
    WHEN '51–55' THEN 4
    WHEN '56–60' THEN 5
    WHEN '61+' THEN 6
END;

SELECT
    CASE loan_approved WHEN 1 THEN 'Approved' ELSE 'Declined' END AS decision,
    COUNT(*) AS applications,
    ROUND(AVG(risk_score), 2) AS avg_risk_score,
    MIN(risk_score) AS min_risk_score,
    MAX(risk_score) AS max_risk_score
FROM loan_applications
GROUP BY loan_approved;

-- Check whether risk score is nearly deterministic of observed approval.
SELECT
    risk_score,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY risk_score
HAVING COUNT(*) >= 10
ORDER BY risk_score;
