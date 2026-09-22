/*
09_interaction_segments.sql
Purpose: move beyond one-variable segmentation and show combined risk profiles.
*/

WITH segments AS (
    SELECT
        CASE
            WHEN annual_income < 60000 THEN '<$60K'
            WHEN annual_income < 120000 THEN '$60–120K'
            ELSE '$120K+'
        END AS income_segment,
        CASE
            WHEN credit_score < 600 THEN '<600'
            WHEN credit_score < 650 THEN '600–649'
            WHEN credit_score < 700 THEN '650–699'
            ELSE '700+'
        END AS credit_segment,
        loan_approved
    FROM loan_applications
)
SELECT
    income_segment,
    credit_segment,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM segments
GROUP BY income_segment, credit_segment
HAVING COUNT(*) >= 50
ORDER BY approval_rate_pct DESC;

WITH profile_segments AS (
    SELECT
        CASE WHEN annual_income >= 120000 THEN 'High income' ELSE 'Lower income' END AS income_profile,
        CASE WHEN previous_loan_defaults = 1 THEN 'Prior default' ELSE 'No prior default' END AS default_profile,
        CASE WHEN bankruptcy_history = 1 THEN 'Prior bankruptcy' ELSE 'No bankruptcy' END AS bankruptcy_profile,
        loan_approved
    FROM loan_applications
)
SELECT
    income_profile,
    default_profile,
    bankruptcy_profile,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM profile_segments
GROUP BY income_profile, default_profile, bankruptcy_profile
HAVING COUNT(*) >= 50
ORDER BY applications DESC;
