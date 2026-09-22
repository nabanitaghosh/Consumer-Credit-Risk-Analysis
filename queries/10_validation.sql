/*
10_validation.sql
Purpose: independently reconcile the primary findings.
*/

-- Control 1: overall population reconciliation
WITH counts AS (
    SELECT
        COUNT(*) AS total_rows,
        SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) AS approved_rows,
        SUM(CASE WHEN loan_approved = 0 THEN 1 ELSE 0 END) AS declined_rows
    FROM loan_applications
)
SELECT
    total_rows,
    approved_rows,
    declined_rows,
    approved_rows + declined_rows AS reconstructed_total,
    CASE
        WHEN total_rows = approved_rows + declined_rows THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status
FROM counts;

-- Control 2: approval rate calculated two different ways
SELECT
    ROUND(100.0 * AVG(loan_approved), 4) AS method_1_avg_flag,
    ROUND(
        100.0 * SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS method_2_count_ratio,
    CASE
        WHEN ROUND(100.0 * AVG(loan_approved), 4)
           = ROUND(100.0 * SUM(CASE WHEN loan_approved = 1 THEN 1 ELSE 0 END) / COUNT(*), 4)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status
FROM loan_applications;

-- Control 3: decision profile totals must reconcile to the overall population
WITH decision_profile AS (
    SELECT loan_approved, COUNT(*) AS applications
    FROM loan_applications
    GROUP BY loan_approved
)
SELECT
    SUM(applications) AS profile_total,
    (SELECT COUNT(*) FROM loan_applications) AS source_total,
    CASE
        WHEN SUM(applications) = (SELECT COUNT(*) FROM loan_applications) THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status
FROM decision_profile;

-- Control 4: small-cell detector for segmented reporting
SELECT
    'income' AS dimension,
    income_band AS segment,
    COUNT(*) AS applications,
    CASE WHEN COUNT(*) < 50 THEN 'REVIEW SMALL CELL' ELSE 'OK' END AS cell_flag
FROM (
    SELECT
        CASE
            WHEN annual_income < 40000 THEN '<$40K'
            WHEN annual_income < 60000 THEN '$40–60K'
            WHEN annual_income < 80000 THEN '$60–80K'
            WHEN annual_income < 120000 THEN '$80–120K'
            WHEN annual_income < 160000 THEN '$120–160K'
            ELSE '$160K+'
        END AS income_band
    FROM loan_applications
)
GROUP BY income_band
ORDER BY applications;

-- Control 5: confirm the two adverse-history fields are binary.
SELECT
    SUM(CASE WHEN bankruptcy_history NOT IN (0,1) OR bankruptcy_history IS NULL THEN 1 ELSE 0 END) AS invalid_bankruptcy_values,
    SUM(CASE WHEN previous_loan_defaults NOT IN (0,1) OR previous_loan_defaults IS NULL THEN 1 ELSE 0 END) AS invalid_default_values
FROM loan_applications;
