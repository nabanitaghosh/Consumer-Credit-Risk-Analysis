/*
07_application_segments.sql
Purpose: compare approval rates across applicant and loan segments.
*/

-- Employment status
SELECT
    employment_status,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY employment_status
ORDER BY approval_rate_pct DESC;

-- Education
SELECT
    education_level,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY education_level
ORDER BY approval_rate_pct DESC;

-- Home ownership
SELECT
    home_ownership_status,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY home_ownership_status
ORDER BY approval_rate_pct DESC;

-- Loan purpose
SELECT
    loan_purpose,
    COUNT(*) AS applications,
    SUM(loan_approved) AS approvals,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY loan_purpose
ORDER BY approval_rate_pct DESC;

-- Loan duration
SELECT
    loan_duration_months,
    COUNT(*) AS applications,
    ROUND(100.0 * AVG(loan_approved), 2) AS approval_rate_pct
FROM loan_applications
GROUP BY loan_duration_months
ORDER BY loan_duration_months;
